import SpriteKit

class CatcherNode: SKSpriteNode, PositionSizeGettable, CatcherPositionerDelegate {

    let PHYSICS_RADIUS: CGFloat = 20
    private var positioner: CatcherPositioner!

    func setup(positioner: CatcherPositioner) {
        self.positioner = positioner
        self.positioner.delegate = self
        physicsBody = SKPhysicsBody(circleOfRadius: PHYSICS_RADIUS)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }

    func onCatcherPositionUpdated() {
        position = positioner.nextPosition
    }

    func isCatchable(shit: PositionSizeGettable) -> Bool {
        return type(of: self).isCatchable(shit: shit, catcher: self)
    }

    static func isCatchable(shit: PositionSizeGettable, catcher: CatcherNode) -> Bool {
        let shitBottomY = shit.y + shit.height / 2
        let isShitOnTheCatcher = shitBottomY > catcher.y
        let isShitXInCatcher = shit.position.x < catcher.position.x + catcher.PHYSICS_RADIUS &&
            catcher.x - catcher.PHYSICS_RADIUS < shit.position.x
        return isShitOnTheCatcher && isShitXInCatcher

    }
}


