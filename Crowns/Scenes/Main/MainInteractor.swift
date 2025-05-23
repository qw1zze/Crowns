//
//  MainInteractor.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 5/5/25.
//

import Foundation

protocol MainBusinessLogic {
    func startGame(request: Main.StartGame.Request)
    func showStats()
}

final class MainInteractor: MainBusinessLogic {
    var presenter: MainPresentationLogic?
    
    init(presenter: MainPresentationLogic?) {
        self.presenter = presenter
    }
    
    func startGame(request: Main.StartGame.Request) {
        let response = Main.StartGame.Response(game: request.game)
        presenter?.presentStartGame(response: response)
    }
    
    func showStats() {
        presenter?.presentShowStats()
    }
} 
