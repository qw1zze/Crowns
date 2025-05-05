import UIKit

protocol QueensDisplayLogic: AnyObject {
    func displayBoard(viewModel: Queens.Board.ViewModel)
    func displayError(message: String)
    func displayWin()
}

final class QueensViewController: UIViewController {
    var interactor: QueensBusinessLogic?
    var router: (QueensRoutingLogic & QueensDataPassing)?
    
    private let boardView = QueensBoardView()
    private let errorLabel = UILabel()
    private let newGameButton = UIButton(type: .system)
    private let hintButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        interactor?.generateNewGame()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Queens"
        
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        
        hintButton.setTitle("Hint", for: .normal)
        newGameButton.setTitle("New Game", for: .normal)
        
        view.addSubview(boardView)
        view.addSubview(errorLabel)
        view.addSubview(hintButton)
        view.addSubview(newGameButton)
    }
    
    private func setupConstraints() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        hintButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            hintButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            hintButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            newGameButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            newGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        boardView.cellSelected = { [weak self] cell in
            self?.interactor?.toggleQueen(at: cell)
        }
        
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hintButtonTapped() {
        interactor?.provideHint()
    }
    
    @objc private func newGameButtonTapped() {
        interactor?.generateNewGame()
    }
}

extension QueensViewController: QueensDisplayLogic {
    func displayBoard(viewModel: Queens.Board.ViewModel) {
        boardView.updateBoard(with: viewModel.cells)
        errorLabel.isHidden = true
    }
    
    func displayError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func displayWin() {
        let alert = UIAlertController(title: "Congratulations!", message: "You've solved the puzzle!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.interactor?.generateNewGame()
        })
        present(alert, animated: true)
    }
}
