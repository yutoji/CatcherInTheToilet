import SpriteKit

class CatcherNode: SKSpriteNode, PositionGettable {

    private var positioner: CatcherPositionerProtocol!

    func setup(positioner: CatcherPositionerProtocol) {
        self.positioner = positioner
    }

    func updatePosition() {
        position = positioner.nextPosition
    }
}


