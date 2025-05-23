//
//  TangoAssembly.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import UIKit

enum TangoAssembly {
    static func assembly() -> UIViewController {
        let viewController = TangoViewController()
        let presenter = TangoPresenter(viewController: viewController)
        let interactor = TangoInteractor(presenter: presenter)
        let router = TangoRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
} 
