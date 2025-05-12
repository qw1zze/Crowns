import UIKit

protocol SudokuDisplayLogic: AnyObject {
    func displayBoard(viewModel: Sudoku.Board.ViewModel)
    func displayError(message: String)
    func displayWin()
    func displayGameOver()
    func displayHint(cell: SudokuCell)
    func displayNewBoard()
}

final class SudokuViewController: UIViewController {
    var interactor: SudokuBusinessLogic?
    var router: (SudokuRoutingLogic & SudokuDataPassing)?
    
    private let boardView = SudokuBoardView()
    private let numberPadView = NumberPadView()
    private let mistakesLabel = UILabel()
    private let actionBarView = ActionBarView()
    private let timerLabel = UILabel()
    
    private var selectedCell: SudokuCell?
    private var mistakesCount = 0
    private var timer: Timer?
    private var secondsElapsed: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        interactor?.generateNewGame()
        startTimer()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showSudokuInstructions))
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        
        timerLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        timerLabel.textColor = .white.withAlphaComponent(0.8)
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
        
        mistakesLabel.text = "Ошибки: 0 / 3"
        mistakesLabel.font = .systemFont(ofSize: 14)
        mistakesLabel.textColor = .white.withAlphaComponent(0.8)
        
        view.addSubview(timerLabel)
        view.addSubview(boardView)
        view.addSubview(numberPadView)
        view.addSubview(mistakesLabel)
        view.addSubview(actionBarView)
    }
    
    private func setupConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        boardView.translatesAutoresizingMaskIntoConstraints = false
        numberPadView.translatesAutoresizingMaskIntoConstraints = false
        mistakesLabel.translatesAutoresizingMaskIntoConstraints = false
        actionBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timerLabel.trailingAnchor.constraint(equalTo: boardView.trailingAnchor, constant: -10),
            
            mistakesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mistakesLabel.leadingAnchor.constraint(equalTo: boardView.leadingAnchor, constant: 10),
            
            boardView.topAnchor.constraint(equalTo: mistakesLabel.bottomAnchor),
            boardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),
            boardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            actionBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionBarView.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 10),
            actionBarView.heightAnchor.constraint(equalToConstant: 70),
            
            numberPadView.topAnchor.constraint(equalTo: actionBarView.bottomAnchor, constant: 20),
            numberPadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            numberPadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            numberPadView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupActions() {
        boardView.cellSelected = { [weak self] cell in
            self?.selectedCell = cell
        }
        
        numberPadView.numberSelected = { [weak self] number in
            guard let self = self, let cell = self.selectedCell else { return }
            self.interactor?.validateAndPlaceNumber(number: number, at: cell)
        }
        
        actionBarView.onHint = { [weak self] in self?.hintButtonTapped() }
        actionBarView.onNewGame = { [weak self] in self?.newGameButtonTapped() }
        actionBarView.onUndo = { [weak self] in self?.undoButtonTapped() }
    }
    
    @objc private func hintButtonTapped() {
        guard let cell = selectedCell else { return }
        interactor?.provideHint(for: cell)
    }
    
    @objc private func newGameButtonTapped() {
        interactor?.generateNewGame()
        startTimer()
    }
    
    @objc private func undoButtonTapped() {
        interactor?.undoLastMove()
    }
    
    @objc private func showSudokuInstructions() {
        let message = "Заполните все клетки поля 9x9 \nцифрами от 1 до 9 так, \nчтобы в каждой строке, \nкаждом столбце и \nкаждом квадрате 3x3 каждая цифра встречалась только один раз.\n\n- Кликните по клетке, чтобы выбрать её.\n- Введите число с помощью панели внизу.\n- Используйте подсказки, если застряли.\n- У вас есть 3 попытки на ошибку."
        let alert = UIAlertController(title: "Как играть", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func startTimer() {
        timer?.invalidate()
        secondsElapsed = 0
        timerLabel.text = "00:00"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.secondsElapsed += 1
            self?.updateTimerLabel()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimerLabel() {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}

extension SudokuViewController: SudokuDisplayLogic {
    func displayBoard(viewModel: Sudoku.Board.ViewModel) {
        boardView.updateBoard(with: viewModel.cells)
        selectedCell = nil
    }
    
    func displayError(message: String) {
        mistakesCount += 1
        updateMistakesLabel()
        if let cell = selectedCell {
            boardView.showErrorOnCell(cell)
        }
        if mistakesCount >= 3 {
            interactor?.handleGameOver()
        }
    }
    
    func displayWin() {
        stopTimer()
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        StatsService.shared.updateStats(for: .sudoku, time: TimeInterval(secondsElapsed))
        let alert = UIAlertController(title: "Вы выиграли!", message: "Вы решили судоку за \(timeString)!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Новая игра", style: .default) { [weak self] _ in
            self?.interactor?.generateNewGame()
            self?.startTimer()
        })
        present(alert, animated: true)
    }
    
    func displayGameOver() {
        stopTimer()
        let alert = UIAlertController(title: "Вы проиграли", message: "Вы сделали слишком много ошибок!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Новая игра", style: .default) { [weak self] _ in
            self?.interactor?.generateNewGame()
            self?.startTimer()
        })
        present(alert, animated: true)
    }
    
    func displayHint(cell: SudokuCell) {
        boardView.highlightCell(cell)
    }
    
    func displayNewBoard() {
        mistakesCount = 0
        updateMistakesLabel()
    }
    
    private func updateMistakesLabel() {
        mistakesLabel.text = "Ошибки: \(mistakesCount) / \(3)"
    }
}
