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
        Расставьте фигуры так, чтобы в каждой строке, столбце, цветовом сегменте и среди соседних ячеек была только одна фигура.\n- Крест ставится первым нажатием, фигура — вторым.\n- Фигуры не могут быть по соседству (включая диагонали).\n- Используйте Undo, Hint, New Game, таймер.
        """
        let alert = UIAlertController(title: "Инструкция", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
} 