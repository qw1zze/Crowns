import Foundation

enum Main {
    enum GameType {
        case sudoku, queens, tango
    }
    
    enum StartGame {
        struct Request {
            let game: GameType
        }
        struct Response {
            let game: GameType
        }
        struct ViewModel {
            let game: GameType
        }
    }
    
    enum ShowStats {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
} 