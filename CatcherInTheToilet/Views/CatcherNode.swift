import SpriteKit

class CatcherNode: SKSpriteNode, PositionSizeGettable, CatcherPositionerDelegate {

    private var positioner: CatcherPositioner!

    func setup(positioner: CatcherPositioner) {
        self.positioner = positioner
        self.positioner.delegate = self
    }

    func onCatcherPositionUpdated() {
        position = positioner.nextPosition
    }
}


