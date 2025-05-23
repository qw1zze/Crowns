//
//  SudokuAssembly.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 4/3/25.
//

import UIKit

enum SudokuAssembly {
    static func assembly() -> UIViewController {
        let viewController = SudokuViewController()
        let presenter = SudokuPresenter(viewController: viewController)
        let interactor = SudokuInteractor(presenter: presenter)
        let router = SudokuRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
} 
