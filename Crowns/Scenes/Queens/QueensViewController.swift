import UIKit

protocol QueensDisplayLogic: AnyObject {
    func displayStartGame(viewModel: Queens.StartGame.ViewModel)
    func displayPlaceQueen(viewModel: Queens.PlaceQueen.ViewModel)
    func displayUndo(viewModel: Queens.Undo.ViewModel)
    func displayHint(viewModel: Queens.Hint.ViewModel)
    func displayValidate(viewModel: Queens.Validate.ViewModel)
}

final class QueensViewController: UIViewController, QueensDisplayLogic {
    var interactor: QueensBusinessLogic?
    var router: (QueensRoutingLogic & QueensDataPassing)?
    var initialSize: Int?

    private let boardView = QueensBoardView()
    private let timerLabel = UILabel()
    private let actionBar = QueensActionBarView()
    private var timer: Timer?
    private var secondsElapsed = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        if let size = initialSize {
            interactor?.startGame(request: .init(size: size))
            startTimer()
        }
    }

    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "Queens"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(instructionTapped))

        timerLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = .gray
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
    }

    private func setupConstraints() {
        [timerLabel, boardView, actionBar].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            boardView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),

            actionBar.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 10),
            actionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupActions() {
        boardView.onCellTap = { [weak self] row, col in
            self?.interactor?.placeQueen(request: .init(row: row, col: col))
        }
        actionBar.onUndo = { [weak self] in self?.interactor?.undo(request: .init()) }
        actionBar.onHint = { [weak self] in self?.interactor?.hint(request: .init()) }
        actionBar.onNewGame = { [weak self] in
            if let size = self?.initialSize {
                self?.interactor?.startGame(request: .init(size: size))
                self?.startTimer()
            }
        }
    }

    @objc private func backTapped() { router?.routeToMain() }
    @objc private func instructionTapped() { router?.showInstructions() }

    private func startTimer() {
        timer?.invalidate()
        secondsElapsed = 0
        timerLabel.text = "00:00"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.secondsElapsed += 1
            self?.updateTimerLabel()
        }
    }
    private func stopTimer() { timer?.invalidate(); timer = nil }
    private func updateTimerLabel() {
        let m = secondsElapsed / 60, s = secondsElapsed % 60
        timerLabel.text = String(format: "%02d:%02d", m, s)
    }

    // MARK: - DisplayLogic
    func displayStartGame(viewModel: Queens.StartGame.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
    }
    func displayPlaceQueen(viewModel: Queens.PlaceQueen.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
        interactor?.validate(request: .init())
    }
    func displayUndo(viewModel: Queens.Undo.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
    }
    func displayHint(viewModel: Queens.Hint.ViewModel) {
        boardView.showHint(row: viewModel.row, col: viewModel.col)
    }
    func displayValidate(viewModel: Queens.Validate.ViewModel) {
        if viewModel.isWin {
            stopTimer()
            let m = secondsElapsed / 60, s = secondsElapsed % 60
            let alert = UIAlertController(title: "Победа!", message: "Вы решили задачу за \(String(format: "%02d:%02d", m, s))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                if let size = self?.initialSize {
                    self?.interactor?.startGame(request: .init(size: size))
                    self?.startTimer()
                }
            })
            present(alert, animated: true)
        }
    }
} 