import Foundation

protocol SudokuPresentationLogic {
    func presentBoard(viewModel: Sudoku.Board.ViewModel)
    func presentError(message: String)
    func presentWin()
    func presentGameOver()
    func presentHint(cell: SudokuCell)
    func presentNewBoard()
}

final class SudokuPresenter: SudokuPresentationLogic {
    private weak var viewController: SudokuDisplayLogic?
    
    init(viewController: SudokuDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentBoard(viewModel: Sudoku.Board.ViewModel) {
        viewController?.displayBoard(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func presentWin() {
        viewController?.displayWin()
    }
    
    func presentGameOver() {
        viewController?.displayGameOver()
    }
    
    func presentHint(cell: SudokuCell) {
        viewController?.displayHint(cell: cell)
    }
    
    func presentNewBoard() {
        viewController?.displayNewBoard()
    }
}
