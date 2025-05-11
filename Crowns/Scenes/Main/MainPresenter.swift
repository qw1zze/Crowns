import Foundation

protocol MainPresentationLogic {
    func presentStartGame(response: Main.StartGame.Response)
    func presentShowStats(response: Main.ShowStats.Response)
}

final class MainPresenter: MainPresentationLogic {
    weak var viewController: MainDisplayLogic?
    
    func presentStartGame(response: Main.StartGame.Response) {
        let viewModel = Main.StartGame.ViewModel(game: response.game)
        viewController?.displayStartGame(viewModel: viewModel)
    }
    
    func presentShowStats(response: Main.ShowStats.Response) {
        viewController?.displayShowStats(viewModel: Main.ShowStats.ViewModel())
    }
} 