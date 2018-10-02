import SpriteKit

class ShitNode: SKSpriteNode, PositionSizeGettable {

    private let DEFAULT_WIDTH: CGFloat = 60.0
    let type: ShitType
    var state: ShitState
    private var _isRunning: Bool = false
    private let _actionMaker: ShitActionMaker

    init(type: ShitType) {
        self.type = type
        self.state = .standby
        let texture = SKTexture(imageNamed: type.filename)
        let size = CGSize(
            width: DEFAULT_WIDTH,
            height: texture.size().height * (DEFAULT_WIDTH / texture.size().width)
        )
        _actionMaker = ShitActionMaker(type: type)
        super.init(texture: texture, color: .clear, size: size)
        self.name = "shit"
        _setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupPhysics() {
        physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        physicsBody?.isDynamic = false
    }

    func start() {
        assert(!_isRunning)
        _isRunning = true
        _startAction()
    }

    func onCatched() {
        assert(_isRunning && state == .falling)
        state = .dead
        _startAction() { [weak self] in
            self?.removeFromParent()
        }
    }

    func onHitsGround() {
        assert(_isRunning && state == .falling)
        state = .dead
        physicsBody?.isDynamic = false
        _startAction() { [weak self] in
            self?.removeFromParent()
        }
    }

    private func _startAction(completion: (() -> Void)? = nil) {
        let action = _actionMaker.make(state: state) { [weak self] in
            self?.removeAllActions()
            completion?()
            self?._gotoNextState()
        }
        run(action)
    }

    private func _gotoNextState() {
        guard let nextState = _nextState(of: state) else {
            return
        }

        if nextState == .falling {
            state = .falling

            physicsBody?.isDynamic = true
            self._startAction()
            return
        }
    }

    private func _nextState(of theState: ShitState) -> ShitState? {
        if theState == .standby {
            return .falling
        }
        return nil
    }

}
