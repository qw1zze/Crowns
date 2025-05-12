import UIKit

protocol TangoDisplayLogic: AnyObject {
    func displayStartGame(viewModel: Tango.StartGame.ViewModel)
    func displayPlaceFigure(viewModel: Tango.PlaceFigure.ViewModel)
    func displayUndo(viewModel: Tango.Undo.ViewModel)
    func displayValidate(viewModel: Tango.Validate.ViewModel)
}

final class TangoViewController: UIViewController, TangoDisplayLogic {
    var interactor: TangoBusinessLogic?
    var router: (TangoRoutingLogic & TangoDataPassing)?

    private let boardView = TangoBoardView()
    private let actionBar = TangoActionBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        interactor?.startGame(request: .init())
    }

    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "Tango"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(instructionTapped))
    }

    private func setupConstraints() {
        [boardView, actionBar].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
        boardView.onCellTap = { [weak self] row, col, figure in
            self?.interactor?.placeFigure(request: .init(row: row, col: col, figure: figure))
        }
        actionBar.onUndo = { [weak self] in self?.interactor?.undo(request: .init()) }
        actionBar.onNewGame = { [weak self] in self?.interactor?.startGame(request: .init()) }
    }

    @objc private func backTapped() { router?.routeToMain() }
    @objc private func instructionTapped() { router?.showInstructions() }

    // MARK: - DisplayLogic
    func displayStartGame(viewModel: Tango.StartGame.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
    }
    func displayPlaceFigure(viewModel: Tango.PlaceFigure.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
        interactor?.validate(request: .init())
    }
    func displayUndo(viewModel: Tango.Undo.ViewModel) {
        boardView.updateBoard(board: viewModel.board)
    }
    func displayValidate(viewModel: Tango.Validate.ViewModel) {
        if viewModel.isWin {
            let alert = UIAlertController(title: "Победа!", message: "Вы решили задачу!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.interactor?.startGame(request: .init())
            })
            present(alert, animated: true)
        }
    }
} 