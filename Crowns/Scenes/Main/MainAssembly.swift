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
        let presenter = MainPresenter(viewController: viewController)
        let interactor = MainInteractor(presenter: presenter)
        let router = MainRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        
        return viewController
    }
} 
