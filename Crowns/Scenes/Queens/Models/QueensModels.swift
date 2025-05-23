//
//  Queens.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import Foundation
import UIKit

enum Queens {
    enum GameSize: Int, CaseIterable {
        var title: String { "\(rawValue) x \(rawValue)" }
        
        case five = 5
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
    }

    struct Cell {
        let row: Int
        let col: Int
        var color: UIColor
        var hasQueen: Bool
        var hasCross: Bool
        var isError: Bool
    }

    struct Board {
        let size: Int
        var cells: [[Cell]]
        var segments: [[(Int, Int)]]
    }

    enum StartGame {
        struct Request { let size: Int }
        struct Response { let board: Board }
        struct ViewModel { let board: Board }
    }

    enum PlaceQueen {
        struct Request { let row: Int; let col: Int }
        struct Response { let board: Board }
        struct ViewModel { let board: Board }
    }

    enum Undo {
        struct Request {}
        struct Response { let board: Board }
        struct ViewModel { let board: Board }
    }

    enum Hint {
        struct Request {}
        struct Response { let row: Int; let col: Int }
        struct ViewModel { let row: Int; let col: Int }
    }

    enum Validate {
        struct Request {}
        struct Response { let isWin: Bool }
        struct ViewModel { let isWin: Bool }
    }
} 
