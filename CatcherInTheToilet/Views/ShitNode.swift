import SpriteKit

class ShitNode: SKSpriteNode {

    private let DEFAULT_WIDTH: CGFloat = 60.0
    let type: ShitType
    var state: ShitState

    init(type: ShitType) {
        self.type = type
        self.state = .standby
        let texture = SKTexture(imageNamed: type.filename)
        let size = CGSize(
            width: DEFAULT_WIDTH,
            height: texture.size().height * (DEFAULT_WIDTH / texture.size().width)
        )
        super.init(texture: texture, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
