import UIKit

final class ActionBarView: UIView {
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?
    
    private let stackView = UIStackView()
    
    private let undoButton = ActionBarButton(title: "Undo", imageName: "arrow.uturn.left")
    private let hintButton = ActionBarButton(title: "Smart Hint", imageName: "wand.and.stars")
    private let newGameButton = ActionBarButton(title: "New Game", imageName: "sparkles")
    
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
        backgroundColor = .secondarySystemBackground
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

final class ActionBarButton: UIButton {
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 12)
        tintColor = .label
        setTitleColor(.label, for: .normal)
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        // Place image above text
        let spacing: CGFloat = 2
        let insetAmount: CGFloat = 8
        self.contentEdgeInsets = UIEdgeInsets(top: insetAmount, left: 0, bottom: insetAmount, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image!.size.width, bottom: -image!.size.height, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -titleLabel!.intrinsicContentSize.height, left: 0, bottom: 0, right: -titleLabel!.intrinsicContentSize.width)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
