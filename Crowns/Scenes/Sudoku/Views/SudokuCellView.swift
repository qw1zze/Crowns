//
//  SudokuCellView.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 6/3/25.
//

import UIKit


final class SudokuCellView: UIButton {
    private let label = UILabel()
    var value: Int = 0
    var isEditable: Bool = true
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .backgrundSecondary
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = .white.withAlphaComponent(0.7)
            layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.2).cgColor
        } else {
            backgroundColor = .backgrundSecondary
            layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    func configure(with cell: SudokuCell) {
        value = cell.value
        isEditable = cell.isEditable
        label.text = cell.value == 0 ? "" : "\(cell.value)"
        label.textColor = .white.withAlphaComponent(0.9)
        isSelected = false
    }
    
    func highlight() {
        backgroundColor = .green.withAlphaComponent(0.3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.updateAppearance()
        }
    }
    
    func showError() {
        let originalColor = backgroundColor
        backgroundColor = .systemRed.withAlphaComponent(0.3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.backgroundColor = originalColor
            self?.updateAppearance()
        }
    }
} 
