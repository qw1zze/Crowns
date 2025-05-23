//
//  MainViewController.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 5/5/25.
//

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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crowns"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigation()
    }
    
    private func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navigation
        appearance.setBackIndicatorImage(
            UIImage(systemName: "chevron.left")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)),
            transitionMaskImage: UIImage(systemName: "chevron.left")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .medium))
        )
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        appearance.backButtonAppearance = backButtonAppearance
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationItem.backButtonTitle = ""
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(titleLabel)
        
        sudokuButton.setTitle("Sudoku", for: .normal)
        sudokuButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        sudokuButton.setTitleColor(.white, for: .normal)
        sudokuButton.backgroundColor = .main1
        sudokuButton.layer.cornerRadius = 16
        sudokuButton.layer.shadowColor = UIColor.black.cgColor
        sudokuButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        sudokuButton.layer.shadowRadius = 8
        sudokuButton.layer.shadowOpacity = 0.3
        sudokuButton.addTarget(self, action: #selector(sudokuTapped), for: .touchUpInside)
        
        queensButton.setTitle("Queens", for: .normal)
        queensButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        queensButton.setTitleColor(.white, for: .normal)
        queensButton.backgroundColor = .main2
        queensButton.layer.cornerRadius = 16
        queensButton.layer.shadowColor = UIColor.black.cgColor
        queensButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        queensButton.layer.shadowRadius = 8
        queensButton.layer.shadowOpacity = 0.3
        queensButton.addTarget(self, action: #selector(queensTapped), for: .touchUpInside)
        
        tangoButton.setTitle("Tango", for: .normal)
        tangoButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        tangoButton.setTitleColor(.white, for: .normal)
        tangoButton.backgroundColor = .main3
        tangoButton.layer.cornerRadius = 16
        tangoButton.layer.shadowColor = UIColor.black.cgColor
        tangoButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        tangoButton.layer.shadowRadius = 8
        tangoButton.layer.shadowOpacity = 0.3
        tangoButton.addTarget(self, action: #selector(tangoTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.bar"), style: .plain, target: self, action: #selector(statsTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(sudokuButton)
        view.addSubview(queensButton)
        view.addSubview(tangoButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sudokuButton.translatesAutoresizingMaskIntoConstraints = false
        queensButton.translatesAutoresizingMaskIntoConstraints = false
        tangoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sudokuButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
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
