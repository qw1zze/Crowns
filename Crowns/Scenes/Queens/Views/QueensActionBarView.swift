//
//  QueensActionBarView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

final class QueensActionBarView: UIView {
    private let stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let undo = ActionQueensBarButton(title: "Назад", imageName: "arrow.uturn.left")
    private let hint = ActionQueensBarButton(title: "Подсказка", imageName: "wand.and.stars")
    private let newGame = ActionQueensBarButton(title: "Новая игра", imageName: "sparkles")
    
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(undo)
        stackView.addArrangedSubview(hint)
        stackView.addArrangedSubview(newGame)
    
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        undo.addTarget(self, action: #selector(undoTap), for: .touchUpInside)
        hint.addTarget(self, action: #selector(hintTap), for: .touchUpInside)
        newGame.addTarget(self, action: #selector(newGameTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func undoTap() {
        onUndo?()
    }
    
    @objc private func hintTap() {
        onHint?()
    }
    
    @objc private func newGameTap() {
        onNewGame?()
    }
}
