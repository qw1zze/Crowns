//
//  QueensPresenter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import Foundation

protocol QueensPresentationLogic {
    func presentStartGame(response: Queens.StartGame.Response)
    func presentPlaceQueen(response: Queens.PlaceQueen.Response)
    func presentUndo(response: Queens.Undo.Response)
    func presentHint(response: Queens.Hint.Response)
    func presentValidate(response: Queens.Validate.Response)
}

final class QueensPresenter: QueensPresentationLogic {
    weak var viewController: QueensDisplayLogic?
    
    init(viewController: QueensDisplayLogic?) {
        self.viewController = viewController
    }

    func presentStartGame(response: Queens.StartGame.Response) {
        viewController?.displayStartGame(viewModel: Queens.StartGame.ViewModel(board: response.board))
    }
    
    func presentPlaceQueen(response: Queens.PlaceQueen.Response) {
        viewController?.displayPlaceQueen(viewModel: Queens.PlaceQueen.ViewModel(board: response.board))
    }
    
    func presentUndo(response: Queens.Undo.Response) {
        viewController?.displayUndo(viewModel: Queens.Undo.ViewModel(board: response.board))
    }
    
    func presentHint(response: Queens.Hint.Response) {
        viewController?.displayHint(viewModel: Queens.Hint.ViewModel(row: response.row, col: response.col))
    }
    
    func presentValidate(response: Queens.Validate.Response) {
        viewController?.displayValidate(viewModel: Queens.Validate.ViewModel(isWin: response.isWin))
    }
} 
