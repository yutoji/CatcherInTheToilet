import SpriteKit

class CatcherNode: SKSpriteNode, PositionGettable {

    private var positioner: CatcherPositioner!

    func setup(positioner: CatcherPositioner) {
        self.positioner = positioner
    }

    func updatePosition() {
        position = positioner.nextPosition
    }
}


