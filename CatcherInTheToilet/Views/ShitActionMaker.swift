import SpriteKit
import UIKit

class ShitActionMaker {
    private typealias _ActionSet = (main: SKAction, sub: SKAction)

    var shitType: ShitType
    private var cache: [ShitState:_ActionSet] = [:]

    init(type: ShitType) {
        self.shitType = type
    }

    func make(state: ShitState, completion: @escaping () -> Void) -> SKAction {
        let actionSet = _getActionSet(of: state)
        let completionAction = SKAction.run {
            completion()
        }
        let mainAction = SKAction.sequence([actionSet.main, completionAction])
        let action = SKAction.group([
            mainAction,
            actionSet.sub
            ])
        return action
    }

    private func _getActionSet(of state: ShitState) -> _ActionSet {
        if let actionSet = cache[state] {
            return actionSet
        }

        let selfClass = type(of: self)
        let actionSet = { () -> _ActionSet in
            switch state {
            case .standby: return selfClass._standbyAction(of: shitType)
            case .falling: return selfClass._fallingAction(of: shitType)
            case .dead:    return selfClass._deadAction(of: shitType)
            }
        }()
        cache[state] = actionSet
        return actionSet
    }

    private static func _standbyAction(of shitType: ShitType) -> (main: SKAction, sub: SKAction) {
        let waitDuration = shitType.makeStandbyInterval()
        let waitAction = SKAction.wait(forDuration: waitDuration)

        let shakingAction = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.rotate(byAngle:  _radians( 5), duration: 0.02),
                SKAction.rotate(byAngle: -_radians(10), duration: 0.04),
                SKAction.rotate(byAngle:  _radians( 5), duration: 0.02),
                ])
        )

        return (main: waitAction, sub: shakingAction)
    }

    private static func _fallingAction(of shitType: ShitType) -> (main: SKAction, sub: SKAction) {
        return (main: SKAction.stop(), sub: SKAction.stop())
    }

    private static func _deadAction(of shitType: ShitType) -> (main: SKAction, sub: SKAction) {
        return (main: SKAction.sequence([SKAction.stop()]), sub: SKAction.sequence([SKAction.stop()]))
    }

    private static func _radians(_ degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
}

