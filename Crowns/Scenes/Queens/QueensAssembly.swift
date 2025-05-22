//
//  QueensAssembly.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

enum QueensAssembly {
    static func assembly(size: Int? = nil) -> UIViewController {
        let viewController = QueensViewController()
        let presenter = QueensPresenter(viewController: viewController)
        let interactor = QueensInteractor(presenter: presenter)
        let router = QueensRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        viewController.initialSize = size
        
        return viewController
    }
}
