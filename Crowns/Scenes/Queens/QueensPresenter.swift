import Foundation

protocol QueensPresentationLogic {
    func presentBoard(viewModel: Queens.Board.ViewModel)
    func presentError(message: String)
    func presentWin()
}

final class QueensPresenter: QueensPresentationLogic {
    private weak var viewController: QueensDisplayLogic?
    
    init(viewController: QueensDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentBoard(viewModel: Queens.Board.ViewModel) {
        viewController?.displayBoard(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
    
    func presentWin() {
        viewController?.displayWin()
    }
}
