//
//  QueensFieldGenerator.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import UIKit

protocol GeneratorStrategy {
    static func generate(size: Int) -> Queens.Board
}

final class QueensFieldGenerator: GeneratorStrategy {
    
    static func isSafe(_ row: Int, _ col: Int, _ queens: [Int]) -> Bool {
        for r in 0..<queens.count {
            if queens[r] == col || abs(row - r) == abs(col - queens[r]) {
                return false
            }
        }
        
        return true
    }

    static func solveNQueens(_ n: Int, _ row: Int = 0, _ queens: [Int] = []) -> [[Int]] {
        if row == n {
            return [queens]
        }
        
        var solutions = [[Int]]()
        
        for col in 0..<n {
            if isSafe(row, col, queens) {
                solutions += solveNQueens(n, row + 1, queens + [col])
            }
        }
        
        return solutions
    }

    static func generateRegions(size: Int, from queens: [Int]) -> ([[Int]], [[(Int, Int)]]) {
        var board = Array(repeating: Array(repeating: -1, count: size), count: size)
        var regions = Array(repeating: [(Int, Int)](), count: size)
        var candidates = [(Int, Int)]()
        
        for row in 0..<size {
            let col = queens[row]
            
            board[row][col] = row
            regions[row].append((row, col))
            
            for (dr, dc) in [(-1,0), (1,0), (0,-1), (0,1)] {
                let nr = row + dr
                let nc = col + dc
                if nr >= 0, nr < size, nc >= 0, nc < size, board[nr][nc] == -1 {
                    candidates.append((nr, nc))
                }
            }
        }
        
        while !candidates.isEmpty {
            let current = candidates.removeFirst()
            if board[current.0][current.1] != -1 {
                continue
            }
            
            var neighborRegions = Set<Int>()
            for (dr, dc) in [(-1,0), (1,0), (0,-1), (0,1)] {
                let nr = current.0 + dr
                let nc = current.1 + dc
                if nr >= 0, nr < size, nc >= 0, nc < size {
                    let regionId = board[nr][nc]
                    if regionId != -1 {
                        neighborRegions.insert(regionId)
                    }
                }
            }
            
            guard let regionId = neighborRegions.randomElement() else {
                candidates.append(current)
                continue
            }
            
            board[current.0][current.1] = regionId
            regions[regionId].append(current)
            
            for (dr, dc) in [(-1,0), (1,0), (0,-1), (0,1)] {
                let nr = current.0 + dr
                let nc = current.1 + dc
                if nr >= 0, nr < size, nc >= 0, nc < size, board[nr][nc] == -1 {
                    candidates.append((nr, nc))
                }
            }
        }
        
        return (board, regions)
    }

    static func generate(size: Int) -> Queens.Board {
        let colors: [UIColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPink, .systemPurple, .systemTeal, .systemYellow, .systemRed, .systemIndigo, .brown, .magenta, .cyan]
        
        let solutions = solveNQueens(size)
        var cells: [[Queens.Cell]] = []
        
        let randomSolution = solutions.randomElement() ?? solutions[0]
        
        let (board, segments) = generateRegions(size: size, from: randomSolution)
        
        var rowCells: [Queens.Cell] = []
        for i in 0..<size {
            rowCells = []
            for j in 0..<size {
                rowCells.append(
                    Queens.Cell(row: i,
                                col: j,
                                color: colors[board[i][j]].withAlphaComponent(0.8),
                                hasQueen: false,
                                hasCross: false,
                                isError: false)
                )
            }
            
            cells.append(rowCells)
        }
        
        return Queens.Board(size: size, cells: cells, segments: segments)
    }
}
