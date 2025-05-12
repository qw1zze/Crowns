import Foundation

protocol MainBusinessLogic {
    func startGame(request: Main.StartGame.Request)
    func showStats()
}

final class MainInteractor: MainBusinessLogic {
    var presenter: MainPresentationLogic?
    
    func startGame(request: Main.StartGame.Request) {
        let response = Main.StartGame.Response(game: request.game)
        presenter?.presentStartGame(response: response)
    }
    
    func showStats() {
        presenter?.presentShowStats()
    }
} 
