//
//  QueensRouter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

protocol QueensRoutingLogic {
    func routeToMain()
    func showInstructions()
}

protocol QueensDataPassing {
    var dataStore: QueensDataStore? { get }
}

final class QueensRouter: QueensRoutingLogic, QueensDataPassing {
    weak var viewController: QueensViewController?
    var dataStore: QueensDataStore?

    func routeToMain() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showInstructions() {
        let message = """
        Ваша цель расставить фигуры так, чтобы в каждой строке, столбце, цветовом регионе была одна ♛\n\nНажмите один раз чтобы разместить x и дважды чтобы разместить ♛. \n\nИспользуйте x чтобы отметить где ♛ не может быть расположена\n\n 2 ♛ не могут располагаться в соседних ячейках, даже по диагонали
        """
        let alert = UIAlertController(title: "Как играть", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
} 
