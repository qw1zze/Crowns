//
//  QueensGeneratorAdapter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 8/5/25.
//

import Foundation
import UIKit

final class QueensGeneratorAdapter: PuzzleGenerator {
    typealias Board = Queens.Board
    
    func generate(size: Int) -> Board {
        return QueensFieldGenerator.generate(size: size)
    }
} 
