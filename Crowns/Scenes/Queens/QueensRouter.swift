import UIKit

protocol QueensRoutingLogic {
    func routeToNewGame()
}

protocol QueensDataPassing {
    var dataStore: QueensDataStore? { get }
}

final class QueensRouter: QueensRoutingLogic, QueensDataPassing {
    weak var viewController: QueensViewController?
    var dataStore: QueensDataStore?
    
    func routeToNewGame() {
        viewController?.interactor?.generateNewGame()
    }
} 