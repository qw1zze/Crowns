//
//  TangoViewController.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import UIKit

protocol TangoDisplayLogic: AnyObject {
    func displayStartGame(viewModel: Tango.StartGame.ViewModel)
    func displayPlaceFigure(viewModel: Tango.PlaceFigure.ViewModel)
    func displayUndo(viewModel: Tango.Undo.ViewModel)
    func displayHint(viewModel: Tango.Hint.ViewModel)
    func displayValidate(viewModel: Tango.Validate.ViewModel)
}

final class TangoViewController: UIViewController, TangoDisplayLogic {
    var interactor: TangoBusinessLogic?
    var router: (TangoRoutingLogic & TangoDataPassing)?

    private let boardView = TangoBoardView()
    private let timerLabel = UILabel()
    private let actionBar = TangoActionBarView()
    private var timer: Timer?
    private var secondsElapsed = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        interactor?.startGame(request: .init())
        startTimer()
    }

    private func setupUI() {
        view.backgroundColor = .background
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(instructionTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white

        timerLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        timerLabel.textColor = .gray
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
    }

    private func setupConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        boardView.translatesAutoresizingMaskIntoConstraints = false
        actionBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(timerLabel)
        view.addSubview(boardView)
        view.addSubview(actionBar)
        
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            boardView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor),

            actionBar.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 20),
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
        actionBar.onHint = { [weak self] in self?.interactor?.hint(request: .init()) }
        actionBar.onNewGame = { [weak self] in
            self?.interactor?.startGame(request: .init())
            self?.startTimer()
        }
    }

    @objc private func backTapped() { router?.routeToMain() }
    @objc private func instructionTapped() {
        let message = """
        Заполните поле солнцами (☀️) и лунами (🌙) по следующим правилам:
        
        - В каждой строке и столбце должно быть по 3 солнца и 3 луны
        - Нельзя ставить больше двух одинаковых символов подряд
        - Знак = означает, что символы в соседних ячейках должны быть одинаковыми
        - Знак × означает, что символы в соседних ячейках должны быть разными
        """
        
        let alert = UIAlertController(title: "Правила игры", message: message, preferredStyle: .alert)
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
    private func stopTimer() { timer?.invalidate(); timer = nil }
    private func updateTimerLabel() {
        let m = secondsElapsed / 60, s = secondsElapsed % 60
        timerLabel.text = String(format: "%02d:%02d", m, s)
    }

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
    func displayHint(viewModel: Tango.Hint.ViewModel) {
        boardView.showHint(row: viewModel.row, col: viewModel.col)
        interactor?.placeFigure(request: Tango.PlaceFigure.Request(row: viewModel.row, col: viewModel.col, figure: viewModel.figure))
    }
    func displayValidate(viewModel: Tango.Validate.ViewModel) {
        if viewModel.isWin {
            stopTimer()
            let m = secondsElapsed / 60, s = secondsElapsed % 60
            StatsService.shared.updateStats(for: .tango, time: TimeInterval(secondsElapsed))
            let alert = UIAlertController(title: "Вы выиграли!", message: "Вы решили Tango за \(String(format: "%02d:%02d", m, s))", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Новая игра", style: .default) { [weak self] _ in
                self?.interactor?.startGame(request: .init())
                self?.startTimer()
            })
            present(alert, animated: true)
        }
    }
} 
