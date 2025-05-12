import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayStartGame(viewModel: Main.StartGame.ViewModel)
    func displayShowStats()
}

final class MainViewController: UIViewController {
    var interactor: MainBusinessLogic?
    var router: (MainRoutingLogic)?
    
    private let sudokuButton = UIButton(type: .system)
    private let queensButton = UIButton(type: .system)
    private let tangoButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "Crowns"
        
        sudokuButton.setTitle("Sudoku", for: .normal)
        sudokuButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        sudokuButton.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        sudokuButton.layer.cornerRadius = 16
        sudokuButton.addTarget(self, action: #selector(sudokuTapped), for: .touchUpInside)
        
        queensButton.setTitle("Queens", for: .normal)
        queensButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        queensButton.backgroundColor = .systemGreen.withAlphaComponent(0.1)
        queensButton.layer.cornerRadius = 16
        queensButton.addTarget(self, action: #selector(queensTapped), for: .touchUpInside)
        
        tangoButton.setTitle("Tango", for: .normal)
        tangoButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        tangoButton.backgroundColor = .systemOrange.withAlphaComponent(0.1)
        tangoButton.layer.cornerRadius = 16
        tangoButton.addTarget(self, action: #selector(tangoTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.bar"), style: .plain, target: self, action: #selector(statsTapped))
        
        view.addSubview(sudokuButton)
        view.addSubview(queensButton)
        view.addSubview(tangoButton)
    }
    
    private func setupConstraints() {
        sudokuButton.translatesAutoresizingMaskIntoConstraints = false
        queensButton.translatesAutoresizingMaskIntoConstraints = false
        tangoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sudokuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            sudokuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            sudokuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            sudokuButton.heightAnchor.constraint(equalToConstant: 70),
            
            queensButton.topAnchor.constraint(equalTo: sudokuButton.bottomAnchor, constant: 32),
            queensButton.leadingAnchor.constraint(equalTo: sudokuButton.leadingAnchor),
            queensButton.trailingAnchor.constraint(equalTo: sudokuButton.trailingAnchor),
            queensButton.heightAnchor.constraint(equalTo: sudokuButton.heightAnchor),
            
            tangoButton.topAnchor.constraint(equalTo: queensButton.bottomAnchor, constant: 32),
            tangoButton.leadingAnchor.constraint(equalTo: sudokuButton.leadingAnchor),
            tangoButton.trailingAnchor.constraint(equalTo: sudokuButton.trailingAnchor),
            tangoButton.heightAnchor.constraint(equalTo: sudokuButton.heightAnchor)
        ])
    }
    
    @objc private func sudokuTapped() {
        interactor?.startGame(request: Main.StartGame.Request(game: .sudoku))
    }
    
    @objc private func queensTapped() {
        interactor?.startGame(request: Main.StartGame.Request(game: .queens))
    }
    
    @objc private func tangoTapped() {
        interactor?.startGame(request: Main.StartGame.Request(game: .tango))
    }
    
    @objc private func statsTapped() {
        interactor?.showStats()
    }
} 

extension MainViewController: MainDisplayLogic {
    func displayStartGame(viewModel: Main.StartGame.ViewModel) {
        router?.routeToGame(type: viewModel.game)
    }
    
    func displayShowStats() {
        router?.routeToStats()
    }
}
