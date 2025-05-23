//
//  TangoPresenter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import Foundation

protocol TangoPresentationLogic {
    func presentStartGame(response: Tango.StartGame.Response)
    func presentPlaceFigure(response: Tango.PlaceFigure.Response)
    func presentUndo(response: Tango.Undo.Response)
    func presentHint(response: Tango.Hint.Response)
    func presentValidate(response: Tango.Validate.Response)
}

final class TangoPresenter: TangoPresentationLogic {
    weak var viewController: TangoDisplayLogic?
    
    init(viewController: TangoDisplayLogic?) {
        self.viewController = viewController
    }

    func presentStartGame(response: Tango.StartGame.Response) {
        viewController?.displayStartGame(viewModel: Tango.StartGame.ViewModel(board: response.board))
    }
    
    func presentPlaceFigure(response: Tango.PlaceFigure.Response) {
        viewController?.displayPlaceFigure(viewModel: Tango.PlaceFigure.ViewModel(board: response.board))
    }
    
    func presentUndo(response: Tango.Undo.Response) {
        viewController?.displayUndo(viewModel: Tango.Undo.ViewModel(board: response.board))
    }
    
    func presentHint(response: Tango.Hint.Response) {
        viewController?.displayHint(viewModel: Tango.Hint.ViewModel(row: response.row, col: response.col, figure: response.figure))
    }
    
    func presentValidate(response: Tango.Validate.Response) {
        viewController?.displayValidate(viewModel: Tango.Validate.ViewModel(isWin: response.isWin))
    }
} 
