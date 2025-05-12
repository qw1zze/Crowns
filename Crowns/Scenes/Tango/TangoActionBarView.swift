import UIKit

final class TangoActionBarView: UIView {
    var onUndo: (() -> Void)?
    var onNewGame: (() -> Void)?

    private let stack = UIStackView()
    private let undo = TangoBarButton(title: "Undo", imageName: "arrow.uturn.left")
    private let newGame = TangoBarButton(title: "New Game", imageName: "sparkles")

    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        [undo, newGame].forEach { stack.addArrangedSubview($0) }
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        undo.addTarget(self, action: #selector(undoTap), for: .touchUpInside)
        newGame.addTarget(self, action: #selector(newGameTap), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }
    @objc private func undoTap() { onUndo?() }
    @objc private func newGameTap() { onNewGame?() }
}

final class TangoBarButton: UIButton {
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
        let spacing: CGFloat = 2
        let insetAmount: CGFloat = 8
        self.contentEdgeInsets = UIEdgeInsets(top: insetAmount, left: 0, bottom: insetAmount, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image!.size.width, bottom: -image!.size.height, right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -titleLabel!.intrinsicContentSize.height, left: 0, bottom: 0, right: -titleLabel!.intrinsicContentSize.width)
    }
    required init?(coder: NSCoder) { fatalError() }
} 