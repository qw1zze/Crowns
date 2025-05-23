//
//  ActionBarView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/3/25.
//

import UIKit

final class ActionBarView: UIView {
    private let stackView = UIStackView()
    
    private let undoButton = SudokuBarButton(title: "Назад", imageName: "arrow.uturn.left")
    private let hintButton = SudokuBarButton(title: "Подсказка", imageName: "wand.and.stars")
    private let newGameButton = SudokuBarButton(title: "Новая игра", imageName: "sparkles")
    
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        backgroundColor = .background
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        
        stackView.addArrangedSubview(undoButton)
        stackView.addArrangedSubview(hintButton)
        stackView.addArrangedSubview(newGameButton)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        undoButton.addTarget(self, action: #selector(undoTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintTapped), for: .touchUpInside)
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
    }
    
    @objc private func undoTapped() {
        onUndo?()
    }
    
    @objc private func hintTapped() {
        onHint?()
    }
    
    @objc private func newGameTapped() {
        onNewGame?()
    }
}
