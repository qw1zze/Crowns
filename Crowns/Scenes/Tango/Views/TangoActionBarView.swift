//
//  TangoActionBarView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import UIKit

final class TangoActionBarView: UIView {
    private let stackView = UIStackView()
    private let undo = TangoBarButton(title: "Undo", imageName: "arrow.uturn.left")
    private let hint = TangoBarButton(title: "Hint", imageName: "wand.and.stars")
    private let newGame = TangoBarButton(title: "New Game", imageName: "sparkles")
    
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(undo)
        stackView.addArrangedSubview(hint)
        stackView.addArrangedSubview(newGame)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
