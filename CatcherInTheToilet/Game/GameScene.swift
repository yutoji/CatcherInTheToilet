import SpriteKit
import UIKit

class GameScene: SKScene {
    private var catcher: CatcherNode!
    private var catcherPositioner: CatcherPositioner!

    override func didMove(to view: SKView) {
        _setup()
    }

    func _setup() {
        // Initialize
        catcher = (childNode(withName: "catcher") as! CatcherNode)
        catcherPositioner = CatcherPositioner()

        // Connects them
        catcher.setup(positioner: catcherPositioner)
        catcherPositioner.setup(catcher: catcher)
    }

    override func update(_ currentTime: TimeInterval) {
        catcherPositioner.onFrameUpdated()
        catcher.updatePosition()
    }

    //MARK: - Touch event handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _handleTouchForCatcher(touch: touches.first!)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        _handleTouchForCatcher(touch: touches.first!)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _handleTouchForCatcher(touch: touches.first!)
        catcherPositioner.onTouchEnd()
    }

    private func _handleTouchForCatcher(touch: UITouch) {
        let touchPosition = touch.location(in: self)
        catcherPositioner.onTouch(touch: touchPosition)
    }
}
