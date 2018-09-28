import SpriteKit

class GameScenePhysicalContactHandler {
    var contact: SKPhysicsContact?

    func handle() -> ContactType {
        assert(contact != nil)
        defer {
            contact = nil
        }
        if let shit = _node(withName: "shit") as? ShitNode,
            let catcher = _node(withName: "catcher") as? CatcherNode {
            let isShitCatchedNow = shit.state == .falling && catcher.isCatchable(shit: shit)
            if isShitCatchedNow {
                return ContactType.shitCatched(shit)
            }
        }
        if let shit = _node(withName: "shit") as? ShitNode,
            let gameScene = _node(withName: "gameScene") as? GameScene {
            if gameScene.isHitGround(shit: shit) {
                return ContactType.shitHitsGround(shit)
            }
        }
        if let shit = _node(withName: "shit") as? ShitNode,
            let shit2 = _node(withName: "shit", orderReverse: true) as? ShitNode {
            let shits = [shit, shit2]
            if shits.contains(where: {$0.state == .dead}) &&
                shits.contains(where: {$0.state == .falling}) {
                let fallingShit = shits.filter({$0.state == .falling})[0]
                return ContactType.shitHitsGroundShit(fallingShit)
            }
        }
        return .none
    }

    // if you wanna get the same name two nodes, use priorityReverse flag reversed on 2nd fetching.
    private func _node(withName name: String, orderReverse: Bool = false) -> SKNode? {
        var lhs = contact?.bodyA.node
        var rhs = contact?.bodyB.node
        if orderReverse { swap(&lhs, &rhs) }
        if lhs?.name == name { return lhs }
        if rhs?.name == name { return rhs }
        return nil
    }

    enum ContactType {
        case shitCatched(ShitNode)
        case shitHitsGround(ShitNode)
        case shitHitsGroundShit(ShitNode)
        case none
    }
}
