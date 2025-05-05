import Foundation

protocol SudokuGeneratorProtocol {
    func generateSudoku() -> (board: [[Int]], solution: [[Int]])
}

final class SudokuGenerator: SudokuGeneratorProtocol {
    func generateSudoku() -> (board: [[Int]], solution: [[Int]]) {
        let solution = generateSolution()
        let board = createPuzzle(from: solution)
        return (board, solution)
    }
    
    private func generateSolution() -> [[Int]] {
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        fillDiagonal(&board)
        solveSudoku(&board)
        return board
    }
    
    private func fillDiagonal(_ board: inout [[Int]]) {
        for i in stride(from: 0, to: 9, by: 3) {
            fillBox(&board, row: i, col: i)
        }
    }
    
    private func fillBox(_ board: inout [[Int]], row: Int, col: Int) {
        var numbers = Array(1...9)
        numbers.shuffle()
        
        var index = 0
        for i in 0..<3 {
            for j in 0..<3 {
                board[row + i][col + j] = numbers[index]
                index += 1
            }
        }
    }
    
    private func solveSudoku(_ board: inout [[Int]]) -> Bool {
        var row = -1
        var col = -1
        var isEmpty = true
        
        for i in 0..<9 {
            for j in 0..<9 {
                if board[i][j] == 0 {
                    row = i
                    col = j
                    isEmpty = false
                    break
                }
            }
            if !isEmpty {
                break
            }
        }
        
        if isEmpty {
            return true
        }
        
        for num in 1...9 {
            if isSafe(board, row: row, col: col, num: num) {
                board[row][col] = num
                
                if solveSudoku(&board) {
                    return true
                }
                
                board[row][col] = 0
            }
        }
        
        return false
    }
    
    private func isSafe(_ board: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for x in 0..<9 {
            if board[row][x] == num {
                return false
            }
        }
        
        // Check column
        for x in 0..<9 {
            if board[x][col] == num {
                return false
            }
        }
        
        // Check 3x3 box
        let startRow = row - row % 3
        let startCol = col - col % 3
        
        for i in 0..<3 {
            for j in 0..<3 {
                if board[i + startRow][j + startCol] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func createPuzzle(from solution: [[Int]]) -> [[Int]] {
        var puzzle = solution
        let cellsToRemove = 10
        
        var positions = [(Int, Int)]()
        for i in 0..<9 {
            for j in 0..<9 {
                positions.append((i, j))
            }
        }
        
        positions.shuffle()
        
        for i in 0..<cellsToRemove {
            let (row, col) = positions[i]
            puzzle[row][col] = 0
        }
        
        return puzzle
    }
} 
