import UIKit

final class QueensActionBarView: UIView {
    var onUndo: (() -> Void)?
    var onHint: (() -> Void)?
    var onNewGame: (() -> Void)?

    private let stack = UIStackView()
    private let undo = ActionQueensBarButton(title: "Undo", imageName: "arrow.uturn.left")
    private let hint = ActionQueensBarButton(title: "Hint", imageName: "wand.and.stars")
    private let newGame = ActionQueensBarButton(title: "New Game", imageName: "sparkles")

    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        [undo, hint, newGame].forEach { stack.addArrangedSubview($0) }
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        undo.addTarget(self, action: #selector(undoTap), for: .touchUpInside)
        hint.addTarget(self, action: #selector(hintTap), for: .touchUpInside)
        newGame.addTarget(self, action: #selector(newGameTap), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    @objc private func undoTap() { onUndo?() }
    @objc private func hintTap() { onHint?() }
    @objc private func newGameTap() { onNewGame?() }
}

final class ActionQueensBarButton: UIButton {
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        config.imagePlacement = .top
        config.imagePadding = 2
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        self.configuration = config
        self.titleLabel?.font = .systemFont(ofSize: 12)
        self.tintColor = .label
    }
    required init?(coder: NSCoder) { fatalError() }
} 
 