//
//  MainPresenter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 5/5/25.
//

import Foundation

protocol MainPresentationLogic {
    func presentStartGame(response: Main.StartGame.Response)
    func presentShowStats()
}

final class MainPresenter: MainPresentationLogic {
    weak var viewController: MainDisplayLogic?
    
    init(viewController: MainDisplayLogic) {
        self.viewController = viewController
    }
    
    func presentStartGame(response: Main.StartGame.Response) {
        let viewModel = Main.StartGame.ViewModel(game: response.game)
        viewController?.displayStartGame(viewModel: viewModel)
    }
    
    func presentShowStats() {
        viewController?.displayShowStats()
    }
} 
