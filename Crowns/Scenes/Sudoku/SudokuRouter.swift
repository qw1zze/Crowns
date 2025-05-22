//
//  SudokuRouter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 4/3/25.
//

import UIKit

protocol SudokuRoutingLogic {
    func routeToNewGame()
}

protocol SudokuDataPassing {
    var dataStore: SudokuDataStore? { get }
}

final class SudokuRouter: SudokuRoutingLogic, SudokuDataPassing {
    weak var viewController: SudokuViewController?
    var dataStore: SudokuDataStore?
    
    func routeToNewGame() {
        viewController?.interactor?.generateNewGame()
    }
} 
