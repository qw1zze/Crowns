import UIKit

protocol MainRoutingLogic {
    func routeToGame(type: Main.GameType)
    func routeToStats()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

final class MainRouter: MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    func routeToGame(type: Main.GameType) {
        switch type {
        case .sudoku:
            let sudokuVC = SudokuViewController()
            let presenter = SudokuPresenter(viewController: sudokuVC)
            let interactor = SudokuInteractor(presenter: presenter)
            let router = SudokuRouter()
            router.viewController = sudokuVC
            router.dataStore = interactor
            sudokuVC.interactor = interactor
            sudokuVC.router = router
            viewController?.navigationController?.pushViewController(sudokuVC, animated: true)
        case .queens, .tango:
            let alert = UIAlertController(title: "В разработке", message: "Игра появится позже", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController?.present(alert, animated: true)
        }
    }
    
    func routeToStats() {
        let alert = UIAlertController(title: "Статистика", message: "Здесь будет статистика игр", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
} 