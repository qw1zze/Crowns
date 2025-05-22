//
//  TangoGeneratorAdapter.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 11/5/25.
//

import Foundation

final class TangoGeneratorAdapter: PuzzleGenerator {
    typealias Board = Tango.Board
    
    func generate(size: Int) -> Board {
        return TangoBoardGenerator.generate(size: size)
    }
} 
