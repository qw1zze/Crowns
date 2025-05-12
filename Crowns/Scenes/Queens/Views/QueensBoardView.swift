import UIKit

final class QueensBoardView: UIView {
    var onCellTap: ((Int, Int) -> Void)?
    private var cellViews: [[QueensCellView]] = []
    private var size: Int = 8
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .background
        layer.cornerRadius = 16
        layer.borderWidth = 0
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
