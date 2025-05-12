import UIKit

final class ActionBarView: UIView {
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?
    
    private let stackView = UIStackView()
    
    private let undoButton = SudokuBarButton(title: "Назад", imageName: "arrow.uturn.left")
    private let hintButton = SudokuBarButton(title: "Подсказка", imageName: "wand.and.stars")
    private let newGameButton = SudokuBarButton(title: "Новая игра", imageName: "sparkles")
    
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
        
        [undoButton, hintButton, newGameButton].forEach { stackView.addArrangedSubview($0) }
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
    
    @objc private func undoTapped() { onUndo?() }
    @objc private func hintTapped() { onHint?() }
    @objc private func newGameTapped() { onNewGame?() }
}

final class SudokuBarButton: UIButton {
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        config.imagePlacement = .top
        config.imagePadding = 2
        config.baseForegroundColor = .primary
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        self.configuration = config
        self.titleLabel?.font = .systemFont(ofSize: 12)
        self.tintColor = .label
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
 
