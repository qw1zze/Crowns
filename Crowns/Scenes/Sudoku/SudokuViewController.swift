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
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "Sudoku"
        
        timerLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = .gray
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
        
        mistakesLabel.text = "Ошибки: 0 / 3"
        mistakesLabel.font = .systemFont(ofSize: 14)
        mistakesLabel.textColor = .gray
        
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
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            timerLabel.trailingAnchor.constraint(equalTo: boardView.trailingAnchor, constant: -10),
            
            mistakesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        let alert = UIAlertController(title: "Congratulations!", message: "You've won the game!\nTime: \(timeString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.interactor?.generateNewGame()
            self?.startTimer()
        })
        present(alert, animated: true)
    }
    
    func displayGameOver() {
        stopTimer()
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        let alert = UIAlertController(title: "Game Over", message: "You've made too many mistakes!\nTime: \(timeString)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
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
