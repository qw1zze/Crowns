import UIKit

final class NumberPadView: UIView {
    private var buttons: [UIButton] = []
    var numberSelected: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        
        // Create number buttons
        for number in 1...9 {
            let button = UIButton(type: .system)
            button.setTitle("\(number)", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
            button.backgroundColor = .systemBackground
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.3
            button.layer.shadowOffset = .zero
            button.layer.shadowRadius = 2
            button.layer.cornerRadius = 8
            button.tag = number
            button.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
            addSubview(button)
            buttons.append(button)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let spacing: CGFloat = 8
        let totalSpacing = spacing * CGFloat(buttons.count - 1)
        let availableWidth = UIScreen.main.bounds.width - 40 - totalSpacing
        let buttonWidth = availableWidth / CGFloat(buttons.count)
        
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonWidth),
                button.heightAnchor.constraint(equalToConstant: buttonWidth * 1.2),
                button.topAnchor.constraint(equalTo: topAnchor),

                
                button.leadingAnchor.constraint(equalTo: index == 0 ? leadingAnchor : buttons[index - 1].trailingAnchor, constant: index == 0 ? 0 : spacing)
            ])
        }
    }
    
    @objc private func numberTapped(_ sender: UIButton) {
        numberSelected?(sender.tag)
    }
} 
