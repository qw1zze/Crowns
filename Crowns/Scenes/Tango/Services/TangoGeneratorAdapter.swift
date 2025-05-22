import Foundation

final class TangoGeneratorAdapter: PuzzleGenerator {
    typealias Board = Tango.Board
    
    func generate(size: Int) -> Board {
        return TangoBoardGenerator.generate(size: size)
    }
} 
