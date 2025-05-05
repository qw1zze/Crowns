import UIKit

final class QueensBoardView: UIView {
    private var cells: [[QueensCellView]] = []
    var cellSelected: ((QueensCell) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBoard()
    }
    
    private func setupBoard() {
        backgroundColor = .systemBackground
        
        // Create 8x8 grid of cells
        for row in 0..<8 {
            var rowCells: [QueensCellView] = []
            for col in 0..<8 {
                let cell = QueensCellView()
                cell.tag = row * 8 + col
                cell.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
                addSubview(cell)
                rowCells.append(cell)
            }
            cells.append(rowCells)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let cellSize = UIScreen.main.bounds.width / 10 // Leave some margin
        
        for row in 0..<8 {
            for col in 0..<8 {
                let cell = cells[row][col]
                cell.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    cell.widthAnchor.constraint(equalToConstant: cellSize),
                    cell.heightAnchor.constraint(equalToConstant: cellSize),
                    cell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(col) * cellSize),
                    cell.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(row) * cellSize)
                ])
            }
        }
    }
    
    func updateBoard(with cells: [[QueensCell]]) {
        for row in 0..<8 {
            for col in 0..<8 {
                let cell = cells[row][col]
                self.cells[row][col].configure(with: cell)
            }
        }
    }
    
    @objc private func cellTapped(_ sender: QueensCellView) {
        let row = sender.tag / 8
        let col = sender.tag % 8
        let cell = QueensCell(row: row, column: col, hasQueen: sender.hasQueen, isUnderAttack: sender.isUnderAttack)
        cellSelected?(cell)
    }
}

final class QueensCellView: UIButton {
    private let queenImageView = UIImageView()
    var hasQueen: Bool = false
    var isUnderAttack: Bool = false
    
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
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray4.cgColor
        
        queenImageView.contentMode = .scaleAspectFit
        queenImageView.image = UIImage(systemName: "crown.fill")
        queenImageView.tintColor = .systemBlue
        queenImageView.isHidden = true
        addSubview(queenImageView)
        
        queenImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            queenImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            queenImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            queenImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            queenImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with cell: QueensCell) {
        hasQueen = cell.hasQueen
        isUnderAttack = cell.isUnderAttack
        
        queenImageView.isHidden = !hasQueen
        
        if isUnderAttack {
            backgroundColor = .systemRed.withAlphaComponent(0.3)
        } else {
            backgroundColor = .systemBackground
        }
    }
} 
