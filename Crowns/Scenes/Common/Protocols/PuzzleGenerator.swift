import Foundation


protocol PuzzleGenerator {
    associatedtype Board
    
    func generate(size: Int) -> Board
} 
