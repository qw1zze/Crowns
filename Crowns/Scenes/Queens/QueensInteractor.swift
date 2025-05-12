import Foundation
import UIKit

protocol QueensBusinessLogic {
    func startGame(request: Queens.StartGame.Request)
    func placeQueen(request: Queens.PlaceQueen.Request)
    func undo(request: Queens.Undo.Request)
    func hint(request: Queens.Hint.Request)
    func validate(request: Queens.Validate.Request)
}

protocol QueensDataStore {
    var board: Queens.Board? { get }
    var history: [Queens.Board] { get }
    var size: Int { get }
}

final class QueensInteractor: QueensBusinessLogic, QueensDataStore {
    var presenter: QueensPresentationLogic?
    var board: Queens.Board?
    var history: [Queens.Board] = []
    var size: Int = 8

    func startGame(request: Queens.StartGame.Request) {
        size = request.size
        let generated = QueensFieldGenerator.generate(size: size)
        board = generated
        history = []
        presenter?.presentStartGame(response: Queens.StartGame.Response(board: generated))
    }

    func placeQueen(request: Queens.PlaceQueen.Request) {
        guard var board = board else { return }
        history.append(board)
        var cell = board.cells[request.row][request.col]
        if cell.hasCross {
            cell.hasCross = false
            cell.hasQueen = true
        } else if cell.hasQueen {
            cell.hasQueen = false
        } else {
            cell.hasCross = true
        }
        board.cells[request.row][request.col] = cell
        self.board = board
        validateBoard()
        presenter?.presentPlaceQueen(response: Queens.PlaceQueen.Response(board: self.board!))
    }

    func undo(request: Queens.Undo.Request) {
        guard let prev = history.popLast() else { return }
        board = prev
        presenter?.presentUndo(response: Queens.Undo.Response(board: prev))
    }

    func hint(request: Queens.Hint.Request) {
        guard let board = board else { return }
        for row in 0..<size {
            for col in 0..<size {
                if isValid(row: row, col: col, board: board) && !board.cells[row][col].hasQueen {
                    var testBoard = board
                    testBoard.cells[row][col].hasQueen = true
                    if canSolve(board: testBoard, queensLeft: size - currentQueensCount(testBoard)) {
                        presenter?.presentHint(response: Queens.Hint.Response(row: row, col: col))
                        return
                    }
                }
            }
        }
    }

    func validate(request: Queens.Validate.Request) {
        let isWin = isWinState()
        presenter?.presentValidate(response: Queens.Validate.Response(isWin: isWin))
    }

    private func validateBoard() {
        guard var board = board else { return }
        for row in 0..<size {
            for col in 0..<size {
                let cell = board.cells[row][col]
                if cell.hasQueen {
                    board.cells[row][col].isError = !isValid(row: row, col: col, board: board)
                } else {
                    board.cells[row][col].isError = false
                }
            }
        }
        self.board = board
    }

    private func isValid(row: Int, col: Int, board: Queens.Board) -> Bool {
        let color = board.cells[row][col].color
        for c in 0..<size where c != col {
            if board.cells[row][c].hasQueen { return false }
        }
        for r in 0..<size where r != row {
            if board.cells[r][col].hasQueen { return false }
        }
        for (r, c) in board.segments.first(where: { $0.contains(where: { $0 == (row, col) }) }) ?? [] {
            print(r, c)
            if (r != row || c != col) && board.cells[r][c].hasQueen { return false }
        }
        
        if row - 1 >= 0, col - 1 >= 0, board.cells[row - 1][col - 1].hasQueen {
            return false
        }
        if row - 1 >= 0, col + 1 < size, board.cells[row - 1][col + 1].hasQueen {
            return false
        }
        if row + 1 < size, col - 1 >= 0, board.cells[row + 1][col - 1].hasQueen {
            return false
        }
        if row + 1 < size, col + 1 < size, board.cells[row + 1][col + 1].hasQueen {
            return false
        }
        print("true")
        return true
    }

    private func isWinState() -> Bool {
        guard let board = board else { return false }
        var queens = 0
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].hasQueen && !board.cells[row][col].isError {
                    queens += 1
                }
            }
        }
        return queens == size
    }

    private func currentQueensCount(_ board: Queens.Board) -> Int {
        var count = 0
        for row in 0..<size {
            for col in 0..<size {
                if board.cells[row][col].hasQueen { count += 1 }
            }
        }
        return count
    }

    private func canSolve(board: Queens.Board, queensLeft: Int) -> Bool {
        if queensLeft == 0 { return true }
        for row in 0..<size {
            for col in 0..<size {
                if isValid(row: row, col: col, board: board) && !board.cells[row][col].hasQueen {
                    var nextBoard = board
                    nextBoard.cells[row][col].hasQueen = true
                    if canSolve(board: nextBoard, queensLeft: queensLeft - 1) {
                        return true
                    }
                }
            }
        }
        return false
    }
} 
