import Foundation

protocol GameModel {
    var state: GameState { get }
    var score: Int { get }
    var enemyInterval: TimeInterval { get }
}

class GameModelImpl: GameModel {
    var state: GameState = .playing
    var score: Int = 0
    var enemyInterval: TimeInterval = 10
}
