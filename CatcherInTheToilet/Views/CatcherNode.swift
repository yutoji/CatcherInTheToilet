import SpriteKit

class CatcherNode: SKSpriteNode, PositionSizeGettable {

    private var positioner: CatcherPositioner!

    func setup(positioner: CatcherPositioner) {
        self.positioner = positioner
    }

    func updatePosition() {
        position = positioner.nextPosition
    }
}


