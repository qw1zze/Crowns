import UIKit

final class QueensBoardView: UIView {
    var onCellTap: ((Int, Int) -> Void)?
    private var cellViews: [[QueensCellView]] = []
    private var size: Int = 8

    func updateBoard(board: Queens.Board) {
        size = board.size
        cellViews.forEach { $0.forEach { $0.removeFromSuperview() } }
        cellViews = []
        for row in 0..<size {
            var rowViews: [QueensCellView] = []
            for col in 0..<size {
                let cell = board.cells[row][col]
                let cellView = QueensCellView()
                cellView.configure(cell: cell)
                cellView.onTap = { [weak self] in self?.onCellTap?(row, col) }
                addSubview(cellView)
                rowViews.append(cellView)
            }
            cellViews.append(rowViews)
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !cellViews.isEmpty else { return }
        let cellSize = min(bounds.width, bounds.height) / CGFloat(size)
        for row in 0..<size {
            for col in 0..<size {
                let cellView = cellViews[row][col]
                cellView.frame = CGRect(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize, width: cellSize, height: cellSize)
            }
        }
    }

    func showHint(row: Int, col: Int) {
        cellViews[row][col].showHint()
    }
}

final class QueensCellView: UIView {
    var onTap: (() -> Void)?
    private let queenImage = UIImageView(image: UIImage(systemName: "crown.fill"))
    private let crossView = UIImageView(image: UIImage(systemName: "xmark"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        addSubview(queenImage)
        addSubview(crossView)
        queenImage.contentMode = .scaleAspectFit
        queenImage.tintColor = .black
        crossView.contentMode = .scaleAspectFit
        crossView.tintColor = .black
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(cell: Queens.Cell) {
        backgroundColor = cell.color
        queenImage.isHidden = !cell.hasQueen
        crossView.isHidden = !cell.hasCross
        queenImage.tintColor = cell.isError ? .red : .black
        layer.borderWidth = 1
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let s = min(bounds.width, bounds.height)
        queenImage.frame = CGRect(x: s*0.2, y: s*0.2, width: s*0.6, height: s*0.6)
        crossView.frame = CGRect(x: s*0.3, y: s*0.3, width: s*0.4, height: s*0.4)
    }

    @objc private func tap() { onTap?() }
    func showHint() {
        layer.borderColor = UIColor.systemYellow.cgColor
        layer.borderWidth = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.layer.borderColor = UIColor.black.cgColor
            self?.layer.borderWidth = 1
        }
    }
} 
