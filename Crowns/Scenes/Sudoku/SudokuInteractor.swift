import Foundation

protocol SudokuBusinessLogic {
    func generateNewGame()
    func validateAndPlaceNumber(number: Int, at cell: SudokuCell)
    func provideHint(for cell: SudokuCell)
    func handleGameOver()
    func undoLastMove()
}

protocol SudokuDataStore {
    var currentBoard: [[Int]] { get }
    var solution: [[Int]] { get }
}

final class SudokuInteractor: SudokuBusinessLogic, SudokuDataStore {
    private let presenter: SudokuPresentationLogic
    private let generator: SudokuGeneratorAdapter
    
    var currentBoard: [[Int]] = []
    var solution: [[Int]] = []
    private var history: [[[Int]]] = []
    
    init(presenter: SudokuPresentationLogic, generator: SudokuGeneratorAdapter = SudokuGeneratorAdapter()) {
        self.presenter = presenter
        self.generator = generator
    }
    
    func generateNewGame() {
        let (board, solution) = generator.generate(size: 9)
        self.currentBoard = board
        self.solution = solution
        self.history = []
        
        let viewModel = Sudoku.Board.ViewModel(cells: convertBoardToCells(board))
        presenter.presentBoard(viewModel: viewModel)
        presenter.presentNewBoard()
    }
    
    func validateAndPlaceNumber(number: Int, at cell: SudokuCell) {
        guard cell.isEditable else {
            presenter.presentError(message: "This cell cannot be edited")
            return
        }
        
        history.append(currentBoard.map { $0 })
        
        if number == solution[cell.row][cell.column] {
            currentBoard[cell.row][cell.column] = number
            let viewModel = Sudoku.Board.ViewModel(cells: convertBoardToCells(currentBoard))
            presenter.presentBoard(viewModel: viewModel)
            
            if isBoardComplete() {
                presenter.presentWin()
            }
        } else {
            presenter.presentError(message: "Incorrect number")
        }
    }
    
    func provideHint(for cell: SudokuCell) {
        guard cell.isEditable else { return }
        
        history.append(currentBoard.map { $0 })
        let correctNumber = solution[cell.row][cell.column]
        currentBoard[cell.row][cell.column] = correctNumber
        let viewModel = Sudoku.Board.ViewModel(cells: convertBoardToCells(currentBoard))
        presenter.presentBoard(viewModel: viewModel)
        presenter.presentHint(cell: cell)
        
        if isBoardComplete() {
            presenter.presentWin()
        }
    }
    
    func handleGameOver() {
        presenter.presentGameOver()
    }
    
    func undoLastMove() {
        guard let previous = history.popLast() else { return }
        currentBoard = previous
        let viewModel = Sudoku.Board.ViewModel(cells: convertBoardToCells(currentBoard))
        presenter.presentBoard(viewModel: viewModel)
    }
    
    private func convertBoardToCells(_ board: [[Int]]) -> [[SudokuCell]] {
        var cells: [[SudokuCell]] = []
        for row in 0..<9 {
            var rowCells: [SudokuCell] = []
            for col in 0..<9 {
                let isEditable = board[row][col] == 0
                let cell = SudokuCell(row: row, column: col, value: board[row][col], isEditable: isEditable)
                rowCells.append(cell)
            }
            cells.append(rowCells)
        }
        return cells
    }
    
    private func isBoardComplete() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if currentBoard[row][col] != solution[row][col] {
                    return false
                }
            }
        }
        return true
    }
} 
 