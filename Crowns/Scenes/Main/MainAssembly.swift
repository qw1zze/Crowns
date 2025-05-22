//
//  MainAssembly.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 5/5/25.
//

import UIKit

enum MainAssembly {
    static func assembly() -> UIViewController {
        let viewController = MainViewController()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
} 
