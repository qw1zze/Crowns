//
//  TangoRouter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import UIKit

protocol TangoRoutingLogic {
    func routeToMain()
    func showInstructions()
}

protocol TangoDataPassing {
    var dataStore: TangoDataStore? { get }
}

final class TangoRouter: TangoRoutingLogic, TangoDataPassing {
    weak var viewController: TangoViewController?
    var dataStore: TangoDataStore?

    func routeToMain() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showInstructions() {
        let message = """
        В каждой строке и столбце по 3 крестика и 3 нолика.\nНе может быть больше двух одинаковых подряд.\n= — между ячейками должны быть одинаковые фигуры.\nx — между ячейками должны быть разные фигуры.
        """
        let alert = UIAlertController(title: "Как играть", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
} 
