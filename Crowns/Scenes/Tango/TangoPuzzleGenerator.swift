import Foundation

struct CellPair: Hashable, Equatable {
    let first: (Int, Int)
    let second: (Int, Int)
    static func == (lhs: CellPair, rhs: CellPair) -> Bool {
        lhs.first == rhs.first && lhs.second == rhs.second
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(first.0)
        hasher.combine(first.1)
        hasher.combine(second.0)
        hasher.combine(second.1)
    }
}
typealias Constraints = [CellPair: String]

final class TangoBoardGenerator {
    static func generate(size: Int = 6) -> Tango.Board {
        let (puzzle, horizontal, vertical) = generatePuzzle(size: size)
        var cells: [[Tango.Cell]] = []
        for row in 0..<size {
            var rowCells: [Tango.Cell] = []
            for col in 0..<size {
                let symbol = puzzle[row][col]
                let figure: Tango.Figure
                let isInitial: Bool
                switch symbol {
                case "X": figure = .cross; isInitial = true
                case "O": figure = .nought; isInitial = true
                default: figure = .empty; isInitial = false
                }
                rowCells.append(Tango.Cell(row: row, col: col, figure: figure, isError: false, isInitial: isInitial))
            }
            cells.append(rowCells)
        }
        return Tango.Board(size: size, cells: cells, horizontalRelations: horizontal, verticalRelations: vertical)
    }

    private static func generatePuzzle(size: Int) -> ([[String?]], [[Tango.Relation]], [[Tango.Relation]]) {
        let (puzzle, constraints) = generatePuzzleAndConstraints(size: size)
        let (horizontal, vertical) = constraintsToRelations(constraints: constraints, size: size)
        return (puzzle, horizontal, vertical)
    }

    private static func generatePuzzleAndConstraints(size: Int) -> ([[String?]], Constraints) {
        let symbols = ["X", "O"]
        let half = size / 2
        let equal = "="
        let different = "≠"
        while true {
            var grid: [[String?]] = Array(repeating: Array(repeating: nil, count: size), count: size)
            let constraints = generateRandomConstraints(size: size, n: 10)
            if fillGrid(grid: &grid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different) {
                var testGrid = grid
                var count = 0
                countSolutions(grid: &testGrid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different, count: &count)
                if count == 1 {
                    let puzzle = maskSolution(fullGrid: grid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different)
                    print(constraints)
                    return (puzzle, constraints)
                }
            }
        }
    }

    private static func constraintsToRelations(constraints: Constraints, size: Int) -> ([[Tango.Relation]], [[Tango.Relation]]) {
        var horizontal: [[Tango.Relation]] = Array(repeating: Array(repeating: .none, count: size-1), count: size)
        var vertical: [[Tango.Relation]] = Array(repeating: Array(repeating: .none, count: size), count: size-1)
        for (pair, sign) in constraints {
            let (r1, c1) = pair.first
            let (r2, c2) = pair.second
            let rel: Tango.Relation = (sign == "=") ? .equal : .notEqual
            if r1 == r2 {
                let row = r1
                let col = min(c1, c2)
                horizontal[row][col] = rel
            } else if c1 == c2 {
                let row = min(r1, r2)
                let col = c1
                vertical[row][col] = rel
            }
        }
        return (horizontal, vertical)
    }

    private static func noThreeConsecutive(_ line: [String?]) -> Bool {
        let str = line.map { $0 ?? "." }.joined()
        return !str.contains("XXX") && !str.contains("OOO")
    }

    private static func isValidCount(_ line: [String?], half: Int) -> Bool {
        let xCount = line.filter { $0 == "X" }.count
        let oCount = line.filter { $0 == "O" }.count
        return xCount <= half && oCount <= half
    }

    private static func checkConstraints(grid: [[String?]], constraints: Constraints, r: Int, c: Int, symbol: String, equal: String, different: String) -> Bool {
        for (pair, sign) in constraints {
            let (ra, ca) = pair.first
            let (rb, cb) = pair.second
            if (r, c) == pair.first || (r, c) == pair.second {
                let other = (r, c) == pair.first ? grid[rb][cb] : grid[ra][ca]
                if let other = other {
                    if sign == equal && other != symbol { return false }
                    if sign == different && other == symbol { return false }
                }
            }
        }
        return true
    }

    private static func fillGrid(grid: inout [[String?]], constraints: Constraints, size: Int, symbols: [String], half: Int, equal: String, different: String, r: Int = 0, c: Int = 0) -> Bool {
        if r == size { return true }
        let (nextR, nextC) = c + 1 < size ? (r, c + 1) : (r + 1, 0)
        for symbol in symbols {
            grid[r][c] = symbol
            let row = grid[r]
            let col = (0..<size).map { grid[$0][c] }
            if isValidCount(row, half: half) && isValidCount(col, half: half) &&
                noThreeConsecutive(row) && noThreeConsecutive(col) &&
                checkConstraints(grid: grid, constraints: constraints, r: r, c: c, symbol: symbol, equal: equal, different: different) {
                if fillGrid(grid: &grid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different, r: nextR, c: nextC) {
                    return true
                }
            }
        }
        grid[r][c] = nil
        return false
    }

    private static func countSolutions(grid: inout [[String?]], constraints: Constraints, size: Int, symbols: [String], half: Int, equal: String, different: String, r: Int = 0, c: Int = 0, count: inout Int) {
        if count > 1 { return }
        if r == size {
            count += 1
            return
        }
        let (nextR, nextC) = c + 1 < size ? (r, c + 1) : (r + 1, 0)
        if grid[r][c] != nil {
            countSolutions(grid: &grid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different, r: nextR, c: nextC, count: &count)
        } else {
            for symbol in symbols {
                grid[r][c] = symbol
                let row = grid[r]
                let col = (0..<size).map { grid[$0][c] }
                if isValidCount(row, half: half) && isValidCount(col, half: half) &&
                    noThreeConsecutive(row) && noThreeConsecutive(col) &&
                    checkConstraints(grid: grid, constraints: constraints, r: r, c: c, symbol: symbol, equal: equal, different: different) {
                    countSolutions(grid: &grid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different, r: nextR, c: nextC, count: &count)
                }
            }
            grid[r][c] = nil
        }
    }

    private static func generateRandomConstraints(size: Int, n: Int = 10) -> Constraints {
        var constraints: Constraints = [:]
        var attempts = 0
        let equal = "="
        let different = "≠"
        while constraints.count < n && attempts < 100 {
            let horizontal = Bool.random()
            let cell1: (Int, Int)
            let cell2: (Int, Int)
            if horizontal {
                let r = Int.random(in: 0..<size)
                let c = Int.random(in: 0..<size - 1)
                cell1 = (r, c)
                cell2 = (r, c + 1)
            } else {
                let r = Int.random(in: 0..<size - 1)
                let c = Int.random(in: 0..<size)
                cell1 = (r, c)
                cell2 = (r + 1, c)
            }
            let pair = CellPair(first: cell1, second: cell2)
            if constraints[pair] == nil {
                constraints[pair] = Bool.random() ? equal : different
            }
            attempts += 1
        }
        return constraints
    }

    private static func maskSolution(fullGrid: [[String?]], constraints: Constraints, size: Int, symbols: [String], half: Int, equal: String, different: String, maxMasked: Int = 20) -> [[String?]] {
        var maskedGrid = fullGrid
        var positions = [(Int, Int)]()
        for r in 0..<size {
            for c in 0..<size {
                positions.append((r, c))
            }
        }
        positions.shuffle()
        var masked = 0
        for (r, c) in positions {
            if masked >= maxMasked { break }
            let original = maskedGrid[r][c]
            maskedGrid[r][c] = nil
            var testGrid = maskedGrid
            var count = 0
            countSolutions(grid: &testGrid, constraints: constraints, size: size, symbols: symbols, half: half, equal: equal, different: different, count: &count)
            if count == 1 {
                masked += 1
            } else {
                maskedGrid[r][c] = original
            }
        }
        return maskedGrid
    }
}
