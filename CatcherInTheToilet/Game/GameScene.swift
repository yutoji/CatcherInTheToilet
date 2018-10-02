import SpriteKit
import UIKit

class GameScene: SKScene, SceneShitDistributorDelegate, SKPhysicsContactDelegate {
    let GROUND_HEIGHT: CGFloat = 5
    private var catcher: CatcherNode!
    private var catcherPositioner: TouchPointCatcherPositioner!
    private var assNodes: [AssNode]!
    private var playStatus: PlayStatus!
    lazy private var scorePane: ScorePane = childNode(withName: "scorePane") as! ScorePane
    private var commentPaneLayer: SKNode!
    private var commentPane: CommentPane!

    var timer: GameTimer!
    private var shitDistributor: SceneShitDistributor!
    private let contactHandler = GameScenePhysicalContactHandler()

    override func didMove(to view: SKView) {
        _setup()

        _startGame()
    }

    func _setup() {
        // Initialize
        catcher = (childNode(withName: "catcher") as! CatcherNode)
        catcherPositioner = TouchPointCatcherPositioner()
        _setupAssNodes()
        _setupShitDistributor()
        commentPaneLayer = childNode(withName: "commentPaneLayer")!

        // Connects them
        catcher.setup(positioner: catcherPositioner)
        catcherPositioner.setup(catcher: catcher)
        _prepareCommentPane()

        // Others
        _setupPhysicsWorld()
    }

    private func _setupAssNodes() {
        assNodes = []
        enumerateChildNodes(withName: "ass") { (eachNode, _) in
            let ass = eachNode as! AssNode
            self.assNodes.append(ass)
        }
    }

    private func _setupShitDistributor() {
        let shitPositionGainable = RandomShitStartPositionGainable(asses: assNodes)
        shitDistributor = NormalSceneShitDistributor(positionGainable: shitPositionGainable, timer: GameTimer(repeats: true))
        shitDistributor.delegate = self
    }

    private func _prepareCommentPane() {
        commentPane = CommentPane(color: .clear, size: size)
        commentPaneLayer.addChild(commentPane)
    }

    private func _setupPhysicsWorld() {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.contactTestBitMask = ContactCategory.UnkoHittable
        physicsWorld.contactDelegate = self
        catcher.physicsBody?.contactTestBitMask = ContactCategory.UnkoHittable
    }

    override func update(_ currentTime: TimeInterval) {
        catcherPositioner.onFrameUpdated()
    }

    private func _startGame() {
        shitDistributor.start()
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.9)
        playStatus = PlayStatus()
        scorePane.playStatus = playStatus
        commentPane.prepare(playStatus: playStatus)
    }

    func onDistributed(newShit: ShitNode) {
        assert(newShit.state == .standby)
        newShit.physicsBody?.contactTestBitMask = ContactCategory.UnkoHittable
        newShit.zPosition = 100
        newShit.start()
        addChild(newShit)
    }

    func isHitGround(shit: ShitNode) -> Bool {
        if shit.state != .falling { return false }
        let shitBottomY = shit.position.y - shit.size.height / 2
        let groundTopY = -self.frame.height / 2 + GROUND_HEIGHT
        let isShitInGround = shitBottomY < groundTopY
        return isShitInGround
    }

    func didBegin(_ contact: SKPhysicsContact) {
        contactHandler.contact = contact
        let contactType = contactHandler.handle()
        switch contactType {
        case let .shitCatched(shitNode):
            shitNode.onCatched()
            playStatus.onShitGot(type: shitNode.type)
        case let .shitHitsGround(shitNode):
            shitNode.onHitsGround()
            playStatus.onShitLost(type: shitNode.type)
        case let .shitHitsGroundShit(shitNode):
            shitNode.onHitsGround()
        case .none:
            break
        }
    }

    struct ContactCategory {
        static let UnkoHittable: UInt32 = 0x1 << 1
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
