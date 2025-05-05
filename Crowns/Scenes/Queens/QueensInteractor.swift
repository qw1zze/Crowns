import Foundation

protocol QueensBusinessLogic {
    func generateNewGame()
    func toggleQueen(at cell: QueensCell)
    func provideHint()
}

protocol QueensDataStore {
    var currentBoard: [[QueensCell]] { get }
}

final class QueensInteractor: QueensBusinessLogic, QueensDataStore {
    private let presenter: QueensPresentationLogic
    private let boardSize = 8
    
    var currentBoard: [[QueensCell]] = []
    
    init(presenter: QueensPresentationLogic) {
        self.presenter = presenter
    }
    
    func generateNewGame() {
        currentBoard = Array(repeating: Array(repeating: QueensCell(row: 0, column: 0, hasQueen: false, isUnderAttack: false), count: boardSize), count: boardSize)
        
        // Initialize cells with correct row and column
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                currentBoard[row][col] = QueensCell(row: row, column: col, hasQueen: false, isUnderAttack: false)
            }
        }
        updateBoard()
    }
    
    func toggleQueen(at cell: QueensCell) {
        var newBoard = currentBoard
        let row = cell.row
        let col = cell.column
        
        // Toggle queen
        newBoard[row][col].hasQueen = !newBoard[row][col].hasQueen
        
        // Update attack status for all cells
        updateAttackStatus(&newBoard)
        
        currentBoard = newBoard
        updateBoard()
    }
    
    func provideHint() {
        // Find a safe position for a queen
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if !currentBoard[row][col].hasQueen && !currentBoard[row][col].isUnderAttack {
                    var newBoard = currentBoard
                    newBoard[row][col].hasQueen = true
                    updateAttackStatus(&newBoard)
                    currentBoard = newBoard
                    updateBoard()
                    return
                }
            }
        }
        
        presenter.presentError(message: "No safe positions available")
    }
    
    private func updateAttackStatus(_ board: inout [[QueensCell]]) {
        // Reset all attack statuses
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                board[row][col].isUnderAttack = false
            }
        }
        
        // Update attack status based on queens' positions
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if board[row][col].hasQueen {
                    // Mark all cells in the same row, column, and diagonals as under attack
                    for i in 0..<boardSize {
                        // Same row
                        if i != col {
                            board[row][i].isUnderAttack = true
                        }
                        // Same column
                        if i != row {
                            board[i][col].isUnderAttack = true
                        }
                    }
                    
                    // Diagonals
                    for i in 1..<boardSize {
                        // Top-left to bottom-right diagonal
                        if row - i >= 0 && col - i >= 0 {
                            board[row - i][col - i].isUnderAttack = true
                        }
                        if row + i < boardSize && col + i < boardSize {
                            board[row + i][col + i].isUnderAttack = true
                        }
                        
                        // Top-right to bottom-left diagonal
                        if row - i >= 0 && col + i < boardSize {
                            board[row - i][col + i].isUnderAttack = true
                        }
                        if row + i < boardSize && col - i >= 0 {
                            board[row + i][col - i].isUnderAttack = true
                        }
                    }
                }
            }
        }
    }
    
    private func updateBoard() {
        let viewModel = Queens.Board.ViewModel(
            cells: currentBoard,
            isComplete: isBoardComplete()
        )
        presenter.presentBoard(viewModel: viewModel)
        
        if isBoardComplete() {
            presenter.presentWin()
        }
    }
    
    private func isBoardComplete() -> Bool {
        var queenCount = 0
        for row in 0..<boardSize {
            for col in 0..<boardSize {
                if currentBoard[row][col].hasQueen {
                    queenCount += 1
                }
            }
        }
        return queenCount == boardSize
    }
} 
