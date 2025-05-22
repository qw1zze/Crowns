//
//  PuzzleGenerator.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 5/1/25.
//

import Foundation

protocol PuzzleGenerator {
    associatedtype Board
    
    func generate(size: Int) -> Board
}
