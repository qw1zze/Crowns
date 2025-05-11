import Foundation

protocol MainBusinessLogic {
    func startGame(request: Main.StartGame.Request)
    func showStats(request: Main.ShowStats.Request)
}

protocol MainDataStore {}

final class MainInteractor: MainBusinessLogic, MainDataStore {
    var presenter: MainPresentationLogic?
    
    func startGame(request: Main.StartGame.Request) {
        let response = Main.StartGame.Response(game: request.game)
        presenter?.presentStartGame(response: response)
    }
    
    func showStats(request: Main.ShowStats.Request) {
        presenter?.presentShowStats(response: Main.ShowStats.Response())
    }
} 