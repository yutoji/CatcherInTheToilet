import SpriteKit
import UIKit

class GameScene: SKScene, SceneShitDistributorDelegate {
    private var catcher: CatcherNode!
    private var catcherPositioner: TouchPointCatcherPositioner!
    private var assNodes: [AssNode]!

    var timer: GameTimer!
    private var shitDistributor: SceneShitDistributor!

    override func didMove(to view: SKView) {
        _setup()

        let shitPositionGainable = RandomShitStartPositionGainable(asses: assNodes)
        shitDistributor = NormalSceneShitDistributor(positionGainable: shitPositionGainable, timer: GameTimer(repeats: true))
        shitDistributor.delegate = self
        shitDistributor.start()
    }

    func onDistributed(newShit: ShitNode) {
        addChild(newShit)
    }

    func _setup() {
        // Initialize
        catcher = (childNode(withName: "catcher") as! CatcherNode)
        catcherPositioner = TouchPointCatcherPositioner()
        _setupAssNodes()

        // Connects them
        catcher.setup(positioner: catcherPositioner)
        catcherPositioner.setup(catcher: catcher)
    }

    override func update(_ currentTime: TimeInterval) {
        catcherPositioner.onFrameUpdated()
    }

    private func _setupAssNodes() {
        assNodes = []
        enumerateChildNodes(withName: "ass") { (eachNode, _) in
            let ass = eachNode as! AssNode
            self.assNodes.append(ass)
        }
    }
}

//MARK: - Touch event handling

extension GameScene {

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
