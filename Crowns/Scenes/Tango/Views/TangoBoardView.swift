import UIKit

final class TangoBoardView: UIView {
    var onCellTap: ((Int, Int, Tango.Figure) -> Void)?
    private var cellViews: [[TangoCellView]] = []
    private var horizontalRelationViews: [[TangoRelationView]] = []
    private var verticalRelationViews: [[TangoRelationView]] = []
    private var size: Int = 6
    private var horizontalRelations: [[Tango.Relation]] = []
    private var verticalRelations: [[Tango.Relation]] = []

    func updateBoard(board: Tango.Board) {
        size = board.size
        horizontalRelations = board.horizontalRelations
        verticalRelations = board.verticalRelations
        cellViews.forEach { $0.forEach { $0.removeFromSuperview() } }
        horizontalRelationViews.forEach { $0.forEach { $0.removeFromSuperview() } }
        verticalRelationViews.forEach { $0.forEach { $0.removeFromSuperview() } }
        cellViews = []
        horizontalRelationViews = []
        verticalRelationViews = []
        for row in 0..<size {
            var rowViews: [TangoCellView] = []
            for col in 0..<size {
                let cell = board.cells[row][col]
                let cellView = TangoCellView()
                cellView.configure(cell: cell)
                cellView.isInitial = cell.isInitial
                cellView.onTap = { [weak self] figure in self?.onCellTap?(row, col, figure) }
                addSubview(cellView)
                rowViews.append(cellView)
            }
            cellViews.append(rowViews)
        }

        for row in 0..<size {
            var rowViews: [TangoRelationView] = []
            for col in 0..<(size-1) {
                let rel = horizontalRelations[safe: row]?[safe: col] ?? .none
                guard rel != .none else { rowViews.append(TangoRelationView()); continue }
                let view = TangoRelationView()
                view.type = (rel == .equal) ? .equal : .cross
                addSubview(view)
                rowViews.append(view)
            }
            horizontalRelationViews.append(rowViews)
        }

        for row in 0..<(size-1) {
            var rowViews: [TangoRelationView] = []
            for col in 0..<size {
                let rel = verticalRelations[safe: row]?[safe: col] ?? .none
                guard rel != .none else { rowViews.append(TangoRelationView()); continue }
                let view = TangoRelationView()
                view.type = (rel == .equal) ? .equal : .cross
                addSubview(view)
                rowViews.append(view)
            }
            verticalRelationViews.append(rowViews)
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !cellViews.isEmpty else { return }
        let cellSize = min(bounds.width, bounds.height) / CGFloat(size)
        let relationSize = cellSize * 0.4
        for row in 0..<size {
            for col in 0..<size {
                let cellView = cellViews[row][col]
                cellView.frame = CGRect(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize, width: cellSize, height: cellSize)
            }
        }

        for row in 0..<size {
            for col in 0..<(size-1) {
                guard let relView = horizontalRelationViews[safe: row]?[safe: col] else { continue }
                let x1 = CGFloat(col) * cellSize + cellSize/2
                let x2 = CGFloat(col+1) * cellSize + cellSize/2
                let y = CGFloat(row) * cellSize + cellSize/2
                let center = CGPoint(x: (x1 + x2)/2, y: y)
                relView.frame = CGRect(x: center.x - relationSize/2, y: center.y - relationSize/2, width: relationSize, height: relationSize)
            }
        }

        for row in 0..<(size-1) {
            for col in 0..<size {
                guard let relView = verticalRelationViews[safe: row]?[safe: col] else { continue }

                let y1 = CGFloat(row) * cellSize + cellSize/2
                let y2 = CGFloat(row+1) * cellSize + cellSize/2
                let x = CGFloat(col) * cellSize + cellSize/2
                let center = CGPoint(x: x, y: (y1 + y2)/2)
                relView.frame = CGRect(x: center.x - relationSize/2, y: center.y - relationSize/2, width: relationSize, height: relationSize)
            }
        }
    }

    func showHint(row: Int, col: Int) {
        cellViews[row][col].showHint()
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}

final class TangoCellView: UIView {
    var onTap: ((Tango.Figure) -> Void)?
    private let imageView = UIImageView()
    private var currentFigure: Tango.Figure = .empty
    var isInitial: Bool = false

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
    required init?(coder: NSCoder) { fatalError() }

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
        case .empty: next = .cross
        case .cross: next = .nought
        case .nought: next = .empty
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
 
