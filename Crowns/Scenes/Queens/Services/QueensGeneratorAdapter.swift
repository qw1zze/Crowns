import Foundation
import UIKit

final class QueensGeneratorAdapter: PuzzleGenerator {
    typealias Board = Queens.Board
    
    func generate(size: Int) -> Board {
        return QueensFieldGenerator.generate(size: size)
    }
} 
