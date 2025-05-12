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
        backgroundColor = .secondarySystemBackground
        
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
        // Don't allow selection of non-editable cells or cells that are already filled
        guard sender.isEditable && sender.value == 0 else { return }
        
        // Deselect previous cell
        selectedCellView?.isSelected = false
        
        // Select new cell
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

final class SudokuCellView: UIButton {
    private let label = UILabel()
    var value: Int = 0
    var isEditable: Bool = true
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.systemGray4.cgColor
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = .systemBlue.withAlphaComponent(0.2)
            layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.2).cgColor
        } else {
            backgroundColor = .systemBackground
            layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    func configure(with cell: SudokuCell) {
        value = cell.value
        isEditable = cell.isEditable
        label.text = cell.value == 0 ? "" : "\(cell.value)"
        label.textColor = isEditable ? .systemBlue : .label
        
        // Reset selection state when cell is configured
        isSelected = false
    }
    
    func highlight() {
        backgroundColor = .systemYellow.withAlphaComponent(0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.updateAppearance()
        }
    }
    
    func showError() {
        let originalColor = backgroundColor
        backgroundColor = .systemRed.withAlphaComponent(0.4)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.backgroundColor = originalColor
            self?.updateAppearance()
        }
    }
} 
