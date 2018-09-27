import UIKit
import SpriteKit

class TouchPointCatcherPositioner: CatcherPositioner {

    var nextPosition: CGPoint = .zero
    private weak var catcher: PositionGettable!

    func setup(catcher: PositionGettable) {
        self.catcher = catcher
        self.nextPosition = catcher.position
    }

    func onTouch(touch touchPosition: CGPoint) {
        nextPosition = CGPoint(x: touchPosition.x, y: catcher.position.y)
    }

    func onTouchEnd() {
    }

    func onFrameUpdated() {

    }
}
