import Foundation

protocol TangoBusinessLogic {
    func startGame(request: Tango.StartGame.Request)
    func placeFigure(request: Tango.PlaceFigure.Request)
    func undo(request: Tango.Undo.Request)
    func hint(request: Tango.Hint.Request)
    func validate(request: Tango.Validate.Request)
}

protocol TangoDataStore {
    var board: Tango.Board? { get }
    var history: [Tango.Board] { get }
}

final class TangoInteractor: TangoBusinessLogic, TangoDataStore {
    var presenter: TangoPresentationLogic?
    var board: Tango.Board?
    var history: [Tango.Board] = []
    let size = 6
    
    init(presenter: TangoPresentationLogic?) {
        self.presenter = presenter
    }

    func startGame(request: Tango.StartGame.Request) {
        let generated = TangoBoardGenerator.generate(size: size)
        board = generated
        history = []
        presenter?.presentStartGame(response: Tango.StartGame.Response(board: generated))
    }

    func placeFigure(request: Tango.PlaceFigure.Request) {
        guard var board = board else { return }
        let cell = board.cells[request.row][request.col]
        if cell.isInitial { return }
        history.append(board)
        var newCell = cell
        newCell.figure = request.figure
        board.cells[request.row][request.col] = newCell
        self.board = board
        validateBoard()
        if let validatedBoard = self.board {
            presenter?.presentPlaceFigure(response: Tango.PlaceFigure.Response(board: validatedBoard))
        }
    }

    func undo(request: Tango.Undo.Request) {
        guard let prev = history.popLast() else { return }
        board = prev
        presenter?.presentUndo(response: Tango.Undo.Response(board: prev))
    }

    func hint(request: Tango.Hint.Request) {
        guard let board = board else { return }
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].figure == .empty {
                    for figure in [Tango.Figure.cross, Tango.Figure.nought] {
                        var testBoard = board
                        testBoard.cells[row][col].figure = figure
                        if isValidMove(row: row, col: col, figure: figure, board: testBoard) {
                            if solve(board: testBoard) {
                                presenter?.presentHint(response: Tango.Hint.Response(row: row, col: col, figure: figure))
                                return
                            }
                        }
                    }
                }
            }
        }
    }

    func validate(request: Tango.Validate.Request) {
        let isWin = isWinState()
        presenter?.presentValidate(response: Tango.Validate.Response(isWin: isWin))
    }

    // MARK: - Валидация

    private func validateBoard() {
        guard var board = board else { return }
        // Сброс ошибок
        for row in 0..<size {
            for col in 0..<size {
                board.cells[row][col].isError = false
            }
        }
        // Проверка по правилам
        for i in 0..<size {
            // Проверка подряд 3 одинаковых в строках и столбцах
            for j in 0..<(size-2) {
                // строки
                let f1 = board.cells[i][j].figure
                let f2 = board.cells[i][j+1].figure
                let f3 = board.cells[i][j+2].figure
                if f1 != .empty && f1 == f2 && f2 == f3 {
                    board.cells[i][j].isError = true
                    board.cells[i][j+1].isError = true
                    board.cells[i][j+2].isError = true
                }
                // столбцы
                let v1 = board.cells[j][i].figure
                let v2 = board.cells[j+1][i].figure
                let v3 = board.cells[j+2][i].figure
                if v1 != .empty && v1 == v2 && v2 == v3 {
                    board.cells[j][i].isError = true
                    board.cells[j+1][i].isError = true
                    board.cells[j+2][i].isError = true
                }
            }

            let rowCounts = board.cells[i].reduce(into: [Tango.Figure.nought: 0, Tango.Figure.cross: 0]) { dict, cell in
                if cell.figure == .nought, let value = dict[.nought] { dict[.nought] = value + 1 }
                if cell.figure == .cross, let value = dict[.cross] { dict[.cross] = value + 1 }
            }
            if rowCounts[.nought] ?? 0 > 3 || rowCounts[.cross] ?? 0 > 3 {
                for col in 0..<size { board.cells[i][col].isError = true }
            }
            let colCounts = (0..<size).reduce(into: [Tango.Figure.nought: 0, Tango.Figure.cross: 0]) { dict, row in
                let f = board.cells[row][i].figure
                if f == .nought, let value = dict[.nought] { dict[.nought] = value + 1 }
                if f == .cross, let value = dict[.cross] { dict[.cross] = value + 1 }
            }
            if colCounts[.nought] ?? 0 > 3 || colCounts[.cross] ?? 0 > 3 {
                for row in 0..<size { board.cells[row][i].isError = true }
            }
        }
        // Проверка знаков = и x
        for row in 0..<size {
            for col in 0..<(size-1) {
                let rel = board.horizontalRelations[row][col]
                let f1 = board.cells[row][col].figure
                let f2 = board.cells[row][col+1].figure
                if rel == .equal {
                    if f1 != .empty && f2 != .empty && f1 != f2 {
                        board.cells[row][col].isError = true
                        board.cells[row][col+1].isError = true
                    }
                } else if rel == .notEqual {
                    if f1 != .empty && f2 != .empty && f1 == f2 {
                        board.cells[row][col].isError = true
                        board.cells[row][col+1].isError = true
                    }
                }
            }
        }
        for row in 0..<(size-1) {
            for col in 0..<size {
                let rel = board.verticalRelations[row][col]
                let f1 = board.cells[row][col].figure
                let f2 = board.cells[row+1][col].figure
                if rel == .equal {
                    if f1 != .empty && f2 != .empty && f1 != f2 {
                        board.cells[row][col].isError = true
                        board.cells[row+1][col].isError = true
                    }
                } else if rel == .notEqual {
                    if f1 != .empty && f2 != .empty && f1 == f2 {
                        board.cells[row][col].isError = true
                        board.cells[row+1][col].isError = true
                    }
                }
            }
        }
        self.board = board
    }

    private func isWinState() -> Bool {
        guard let board = board else { return false }
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].figure == .empty || board.cells[row][col].isError {
                    return false
                }
            }
        }
        return true
    }

    private func isValidMove(row: Int, col: Int, figure: Tango.Figure, board: Tango.Board) -> Bool {
        var testBoard = board
        testBoard.cells[row][col].figure = figure
        
        // Проверка на 3 подряд
        for i in 0..<size {
            // Проверка строк
            for j in 0..<(size-2) {
                let f1 = testBoard.cells[i][j].figure
                let f2 = testBoard.cells[i][j+1].figure
                let f3 = testBoard.cells[i][j+2].figure
                if f1 != .empty && f1 == f2 && f2 == f3 {
                    return false
                }
            }
            // Проверка столбцов
            for j in 0..<(size-2) {
                let f1 = testBoard.cells[j][i].figure
                let f2 = testBoard.cells[j+1][i].figure
                let f3 = testBoard.cells[j+2][i].figure
                if f1 != .empty && f1 == f2 && f2 == f3 {
                    return false
                }
            }
        }

        // Проверка количества в строках и столбцах
        for i in 0..<size {
            let rowCounts = testBoard.cells[i].reduce(into: [Tango.Figure.nought: 0, Tango.Figure.cross: 0]) { dict, cell in
                if cell.figure == .nought, let value = dict[.nought] { dict[.nought] = value + 1 }
                if cell.figure == .cross, let value = dict[.cross] { dict[.cross] = value + 1 }
            }
            if rowCounts[.nought] ?? 0 > 3 || rowCounts[.cross] ?? 0 > 3 {
                return false
            }
            let colCounts = (0..<size).reduce(into: [Tango.Figure.nought: 0, Tango.Figure.cross: 0]) { dict, row in
                let f = testBoard.cells[row][i].figure
                
                if f == .nought, let value = dict[.nought] { dict[.nought] = value + 1 }
                if f == .cross, let value = dict[.cross] { dict[.cross] = value + 1 }
            }
            if colCounts[.nought] ?? 0 > 3 || colCounts[.cross] ?? 0 > 3 {
                return false
            }
        }

        // Проверка связей
        for row in 0..<size {
            for col in 0..<(size-1) {
                let rel = testBoard.horizontalRelations[row][col]
                let f1 = testBoard.cells[row][col].figure
                let f2 = testBoard.cells[row][col+1].figure
                if rel == .equal {
                    if f1 != .empty && f2 != .empty && f1 != f2 {
                        return false
                    }
                } else if rel == .notEqual {
                    if f1 != .empty && f2 != .empty && f1 == f2 {
                        return false
                    }
                }
            }
        }
        for row in 0..<(size-1) {
            for col in 0..<size {
                let rel = testBoard.verticalRelations[row][col]
                let f1 = testBoard.cells[row][col].figure
                let f2 = testBoard.cells[row+1][col].figure
                if rel == .equal {
                    if f1 != .empty && f2 != .empty && f1 != f2 {
                        return false
                    }
                } else if rel == .notEqual {
                    if f1 != .empty && f2 != .empty && f1 == f2 {
                        return false
                    }
                }
            }
        }
        return true
    }

    // Solver: возвращает true, если доску можно решить до конца
    private func solve(board: Tango.Board) -> Bool {
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].figure == .empty {
                    for figure in [Tango.Figure.cross, Tango.Figure.nought] {
                        var testBoard = board
                        testBoard.cells[row][col].figure = figure
                        if isValidMove(row: row, col: col, figure: figure, board: testBoard) {
                            if solve(board: testBoard) {
                                return true
                            }
                        }
                    }
                    return false // если ни одна фигура не подходит
                }
            }
        }
        // Если нет пустых клеток, проверяем финальную валидность
        // (нет ошибок и все клетки заполнены)
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].figure == .empty || board.cells[row][col].isError {
                    return false
                }
            }
        }
        return true
    }
} 
