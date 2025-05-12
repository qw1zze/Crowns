import Foundation

public enum Tango {
    public enum Figure: String, CaseIterable {
        case empty = "", nought = "O", cross = "X"
    }

    public struct Cell {
        public let row: Int
        public let col: Int
        public var figure: Figure
        public var isError: Bool
        public var isInitial: Bool
        public init(row: Int, col: Int, figure: Figure, isError: Bool, isInitial: Bool = false) {
            self.row = row
            self.col = col
            self.figure = figure
            self.isError = isError
            self.isInitial = isInitial
        }
    }

    public enum Relation {
        case equal, notEqual, none
    }

    public struct Board {
        public let size: Int
        public var cells: [[Cell]]
        public var horizontalRelations: [[Relation]] // [row][col] — между col и col+1
        public var verticalRelations: [[Relation]]   // [row][col] — между row и row+1
        public init(size: Int, cells: [[Cell]], horizontalRelations: [[Relation]], verticalRelations: [[Relation]]) {
            self.size = size
            self.cells = cells
            self.horizontalRelations = horizontalRelations
            self.verticalRelations = verticalRelations
        }
    }

    public enum StartGame {
        public struct Request {}
        public struct Response { public let board: Board }
        public struct ViewModel { public let board: Board }
    }

    public enum PlaceFigure {
        public struct Request { public let row: Int; public let col: Int; public let figure: Figure }
        public struct Response { public let board: Board }
        public struct ViewModel { public let board: Board }
    }

    public enum Undo {
        public struct Request {}
        public struct Response { public let board: Board }
        public struct ViewModel { public let board: Board }
    }

    public enum Hint {
        public struct Request {}
        public struct Response { 
            public let row: Int
            public let col: Int
            public let figure: Figure
        }
        public struct ViewModel { 
            public let row: Int
            public let col: Int
            public let figure: Figure
        }
    }

    public enum Validate {
        public struct Request {}
        public struct Response { public let isWin: Bool }
        public struct ViewModel { public let isWin: Bool }
    }
} 