import UIKit

protocol MainRoutingLogic {
    func routeToGame(type: Main.GameType)
    func routeToStats()
}

final class MainRouter: MainRoutingLogic {
    weak var viewController: MainViewController?
    
    func routeToGame(type: Main.GameType) {
        switch type {
        case .sudoku:
            let sudokuViewController = SudokuAssembly.assembly()
            viewController?.navigationController?.pushViewController(sudokuViewController, animated: true)
        case .queens:
            let selector = QueensSizeSelectorViewController()
            selector.modalPresentationStyle = .overFullScreen
            selector.onSizeSelected = { [weak self] size in
                let queensViewController = QueensAssembly.assembly(size: size)
                self?.viewController?.navigationController?.pushViewController(queensViewController, animated: true)
            }
            viewController?.present(selector, animated: true)
        case .tango:
            let tangoViewController = TangoAssembly.assembly()
            viewController?.navigationController?.pushViewController(tangoViewController, animated: true)
        }
    }
    
    func routeToStats() {
        let statsViewController = UINavigationController(rootViewController: StatsViewController())
        statsViewController.modalPresentationStyle = .automatic
        viewController?.present(statsViewController, animated: true)
    }
}
