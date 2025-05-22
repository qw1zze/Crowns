//
//  QueensSizeSelectorViewController.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

final class QueensSizeSelectorViewController: UIViewController {
    var onSizeSelected: ((Int) -> Void)?
    private let stack = UIStackView()
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupAlert()
    }
    
    private func setupAlert() {
        let alertView = UIView()
        alertView.backgroundColor = .background
        alertView.layer.cornerRadius = 18
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 320)
        ])
        titleLabel.text = "Выберите размер поля"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16)
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -24)
        ])
        
        for size in Queens.GameSize.allCases {
            let button = UIButton(type: .system)
            button.setTitle(size.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            button.tintColor = .white
            button.backgroundColor = .backgrundSecondary
            button.layer.cornerRadius = 10
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.addTarget(self, action: #selector(sizeTapped(_:)), for: .touchUpInside)
            button.tag = size.rawValue
            stack.addArrangedSubview(button)
        }
        
        let cancel = UIButton(type: .system)
        cancel.setTitle("Отмена", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.setTitleColor(.systemRed, for: .normal)
        cancel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        stack.addArrangedSubview(cancel)
    }
    
    @objc private func sizeTapped(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.onSizeSelected?(sender.tag)
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
} 
