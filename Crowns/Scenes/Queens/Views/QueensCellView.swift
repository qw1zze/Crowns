//
//  QueensCellView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import Foundation
import UIKit

final class QueensCellView: UIView {
    var onTap: (() -> Void)?
    private let queenImage = UIImageView(image: UIImage(systemName: "crown.fill"))
    private let crossView = UIImageView(image: UIImage(systemName: "xmark"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        addSubview(queenImage)
        addSubview(crossView)
        queenImage.contentMode = .scaleAspectFit
        queenImage.tintColor = .white.withAlphaComponent(0.9)
        crossView.contentMode = .scaleAspectFit
        crossView.tintColor = .black
        layer.borderWidth = 0
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(cell: Queens.Cell) {
        backgroundColor = cell.color
        queenImage.isHidden = !cell.hasQueen
        crossView.isHidden = !cell.hasCross
        crossView.tintColor = .white.withAlphaComponent(0.9)
        queenImage.tintColor = cell.isError ? .red : .white.withAlphaComponent(0.9)
        layer.borderWidth = 1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let s = min(bounds.width, bounds.height)
        queenImage.frame = CGRect(x: s*0.2, y: s*0.2, width: s*0.6, height: s*0.6)
        crossView.frame = CGRect(x: s*0.3, y: s*0.3, width: s*0.4, height: s*0.4)
    }

    @objc private func tap() { onTap?() }
    func showHint() {
        layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        layer.borderWidth = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.layer.borderColor = UIColor.black.cgColor
            self?.layer.borderWidth = 1
        }
    }
} 
