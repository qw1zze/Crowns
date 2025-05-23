//
//  SudokuGeneratorAdapter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/3/25.
//

import Foundation

final class SudokuGeneratorAdapter: PuzzleGenerator {
    typealias Board = (board: [[Int]], solution: [[Int]])
    
    private let generator: SudokuGeneratorProtocol
    
    init(generator: SudokuGeneratorProtocol = SudokuGenerator()) {
        self.generator = generator
    }
    
    func generate(size: Int) -> Board {
        return generator.generateSudoku()
    }
} 
