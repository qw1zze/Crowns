import UIKit

final class SudokuBoardView: UIView {
    private var cells: [[SudokuCellView]] = []
    var cellSelected: ((SudokuCell) -> Void)?
    private var selectedCellView: SudokuCellView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBoard()
    }
    
    private func setupBoard() {
        backgroundColor = .clear
        
        for row in 0..<9 {
            var rowCells: [SudokuCellView] = []
            for col in 0..<9 {
                let cell = SudokuCellView()
                cell.tag = row * 9 + col
                cell.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
                addSubview(cell)
                rowCells.append(cell)
            }
            cells.append(rowCells)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let cellSize = UIScreen.main.bounds.width / 11
        let separatorSize: CGFloat = cellSize  / 4
        
        var verticalConstraint: NSLayoutYAxisAnchor = topAnchor
        var horizontalConstraint: NSLayoutXAxisAnchor = leadingAnchor
        
        for row in 0..<9 {
            for col in 0..<9 {
                let cell = cells[row][col]
                cell.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    cell.widthAnchor.constraint(equalToConstant: cellSize),
                    cell.heightAnchor.constraint(equalToConstant: cellSize),
                    cell.leadingAnchor.constraint(equalTo: horizontalConstraint, constant: (col % 3 == 0 ? separatorSize : 0)),
                    cell.topAnchor.constraint(equalTo: verticalConstraint, constant: (row % 3 == 0 ? separatorSize : 0))
                ])
                horizontalConstraint = cell.trailingAnchor
                if col == 8 {
                    horizontalConstraint = leadingAnchor
                    verticalConstraint = cell.bottomAnchor
                }
            }
        }
    }
    
    func updateBoard(with cells: [[SudokuCell]]) {
        print("aaaaa")
        for row in 0..<9 {
            for col in 0..<9 {
                let cell = cells[row][col]
                self.cells[row][col].configure(with: cell)
            }
        }
    }
    
    func highlightCell(_ cell: SudokuCell) {
        cells[cell.row][cell.column].highlight()
    }
    
    @objc private func cellTapped(_ sender: SudokuCellView) {
        guard sender.isEditable && sender.value == 0 else { return }
        
        selectedCellView?.isSelected = false
        
        sender.isSelected = true
        selectedCellView = sender
        
        let row = sender.tag / 9
        let col = sender.tag % 9
        let cell = SudokuCell(row: row, column: col, value: sender.value, isEditable: sender.isEditable)
        cellSelected?(cell)
    }
    
    func showErrorOnCell(_ cell: SudokuCell) {
        let cellView = cells[cell.row][cell.column]
        cellView.showError()
    }
}
