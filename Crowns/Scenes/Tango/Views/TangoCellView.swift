//
//  TangoCellView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 18/5/25.
//

import UIKit

final class TangoCellView: UIView {
    private let imageView = UIImageView()
    private var currentFigure: Tango.Figure = .empty
    var isInitial: Bool = false
    
    var onTap: ((Tango.Figure) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgrundSecondary
        layer.cornerRadius = 8
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.2
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(cell: Tango.Cell) {
        currentFigure = cell.figure
        
        switch cell.figure {
        case .cross:
            imageView.image = UIImage(systemName: "sun.max.fill")
            imageView.tintColor = .orange
        case .nought:
            imageView.image = UIImage(systemName: "moon.fill")
            imageView.tintColor = .systemBlue
        case .empty:
            imageView.image = nil
        }
        
        backgroundColor = cell.isError ? UIColor.systemRed.withAlphaComponent(0.4) : (cell.isInitial ? UIColor.backgrundSecondary.withAlphaComponent(0.2) : .backgrundSecondary)
        isInitial = cell.isInitial
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = bounds.width * 0.2
        imageView.frame = bounds.insetBy(dx: padding, dy: padding)
    }

    @objc private func tap() {
        guard !isInitial else { return }
        let next: Tango.Figure
        
        switch currentFigure {
        case .empty:
            next = .cross
        case .cross:
            next = .nought
        case .nought:
            next = .empty
        }
        
        onTap?(next)
    }

    func showHint() {
        layer.borderColor = UIColor.systemYellow.cgColor
        layer.borderWidth = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.layer.borderColor = UIColor.systemGray4.cgColor
            self?.layer.borderWidth = 1
        }
    }
} 
