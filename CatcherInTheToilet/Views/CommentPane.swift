import UIKit
import SpriteKit

class CommentPane: SKSpriteNode {
    var playStatus: PlayStatusProtocol!
    var comments: [CommentPaneComment] = []
    let TOP_MARGIN: CGFloat = 120
    let COMMENT_STREAM_INTERVAL: TimeInterval = 5

    func prepare(playStatus: PlayStatusProtocol) {
        self.playStatus = playStatus
        playStatus.appendDelegate(delegate: self)
    }

    private func _addComment(withText text: String) {
        let comment = CommentPaneComment(text: text, startedAt: Date())
        _addComment(comment: comment)
    }

    private func _addComment(comment: CommentPaneComment) {
        let logic = CommentStreamLogic(screenWidth: scene!.size.width, streamTimeSpan: COMMENT_STREAM_INTERVAL)
        let logicItem = comment.logicItem
        var y = scene!.size.height / 2.0 - TOP_MARGIN
        for _ in 0...999 {
            let sameLineComments = comments.filter({ $0.position.y == y })
            let collidableComments = sameLineComments.filter({
                logic.willCollide(preceding: $0.logicItem, succeeding: logicItem)
            })
            let isCollideThisLine = collidableComments.count > 0
            if !isCollideThisLine {
                break
            }
            y -= comment.DEFAULT_FONT_SIZE + comment.BOTTOM_MARGIN
        }
        comment.position.y = y

        comments.append(comment)
        addChild(comment)
        _setStreamAction(comment: comment)
    }

    private func _setStreamAction(comment: CommentPaneComment) {
        comment.position.x = scene!.size.width / 2.0
        let actions = [
            SKAction.moveTo(x: -scene!.size.width/2.0 - comment.label.frame.width,
                            duration: COMMENT_STREAM_INTERVAL),
            SKAction.run {
                self._discardComment(comment: comment)
            }
        ]
        comment.run(SKAction.sequence(actions))
    }

    private func _discardComment(comment: CommentPaneComment) {
        comment.removeAllActions()
        comment.removeFromParent()
        if let index = comments.firstIndex(of: comment) {
            comments.remove(at: index)
        }
    }

}

extension CommentPane: PlayStatusDelegate {

    func onScoreUpdated(diff: Int) {
        if diff > 0 {
            _addComment(withText: "Got \(diff) points")
        }
        else if diff < 0 {
            _addComment(withText: "\(-diff) point Lost! omg")
        }
        else {
            let randInt = Int.random(in: 0...100) % 3
            if randInt == 0 {
                _addComment(withText: "Getting bored.")
            } else if randInt == 1 {
                _addComment(withText: "Do something, plz")
            } else {
                _addComment(withText: "Are you sleeping?")
            }
        }
        _addComment(withText: "SCORE: \(playStatus.score)")
    }

    func onEventOccured(event: PlayEvent) {
        let info = _CommentInfoGenerator(event: event).generate()
        _addComment(withText: info.text)
    }
}

class CommentPaneComment: SKSpriteNode {
    let DEFAULT_FONT_SIZE: CGFloat = 50
    let BOTTOM_MARGIN: CGFloat = 24
    let RIGHT_MARGIN: CGFloat = 12
    var startedAt: Date!
    var label: SKLabelNode!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(text: String, startedAt: Date) {
        self.startedAt = startedAt
        self.label = SKLabelNode(fontNamed: "Chalkduster")

        super.init(texture: nil, color: .clear, size: .zero)

        alpha = 0.5
        anchorPoint = .zero
        label.text = text
        label.fontSize = DEFAULT_FONT_SIZE
        label.verticalAlignmentMode = .top
        label.horizontalAlignmentMode = .left
        addChild(label)
    }

    var logicItem: CommentStreamLogicItem {
        return CommentStreamLogicItemImpl(
            width: label.frame.width + RIGHT_MARGIN,
            startedAt: startedAt
        )
    }
}

fileprivate class _CommentInfoGenerator {
    var event: PlayEvent

    init(event: PlayEvent) {
        self.event = event
    }

    func generate() -> (text: String, color: UIColor) {
        let text = getLabelText()
        let color = getColor()
        return (text: text, color: color)
    }

    private func getLabelText() -> String {
        switch event {
        case let .gotShit(shitType):
            return "You Got one " + shitType.theName + "! :)"
        case let .lostShit(shitType):
            return "Oh Noooooooooooo!! You Lost one " + shitType.theName + "! :("
        }
    }

    private func getColor() -> UIColor {
        return .white
    }
}
