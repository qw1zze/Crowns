import Foundation

enum Main {
    enum GameType {
        case sudoku
        case queens
        case tango
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
} 
