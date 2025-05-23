//
//  QueensSizeSelectorViewController.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

final class QueensSizeSelectorViewController: UIViewController {
    private let alertView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    var onSizeSelected: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupAlert()
        setupTitle()
        setupStackView()
        setupButtons()
    }
    
    private func setupAlert() {
        alertView.backgroundColor = .background
        alertView.layer.cornerRadius = 18
        
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    private func setupTitle() {
        titleLabel.text = "Выберите размер поля"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        
        alertView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupButtons() {
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
            stackView.addArrangedSubview(button)
        }
        
        let cancel = UIButton(type: .system)
        cancel.setTitle("Отмена", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16)
        cancel.setTitleColor(.systemRed, for: .normal)
        cancel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        stackView.addArrangedSubview(cancel)
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
