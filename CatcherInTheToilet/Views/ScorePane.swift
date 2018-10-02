import SpriteKit

class ScorePane: SKNode {

    let DEFAULT_ALPHA: CGFloat = 0.5

    lazy var scoreLabel: SKLabelNode! = {
        return childNode(withName: "scoreLabel") as! SKLabelNode
    }()

    var playStatus: PlayStatusProtocol! {
        didSet {
            playStatus.appendDelegate(delegate: self)
        }
    }

    private func _update(diffScore: Int) {
        scoreLabel.text = String(describing: playStatus.score)
        scoreLabel.removeAllActions()
        scoreLabel.alpha = 1.0
        scoreLabel.color = diffScore > 0 ? _getSuccessColor() : .red
        scoreLabel.setScale(diffScore > 0 ? 2.0 : 1.0)
        let actions = [
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.scale(to: 1.0, duration: 1),
                SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 1),
                ]),
            SKAction.fadeAlpha(to: DEFAULT_ALPHA, duration: 1),
        ]
        let actionAll = SKAction.group(actions)
        scoreLabel.run(actionAll)
    }

    private func _getSuccessColor() -> UIColor {
        return .white
    }

    override func move(toParent parent: SKNode) {
        alpha = DEFAULT_ALPHA
    }

}

extension ScorePane: PlayStatusDelegate {

    func onScoreUpdated(diff: Int) {
        _update(diffScore: diff)
    }

    func onEventOccured(event: PlayEvent) {
    }

}
