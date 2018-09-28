import UIKit

protocol PositionGettable: class {
    var position: CGPoint { get }
}

extension PositionGettable {
    var x: CGFloat {
        return position.x
    }
    var y: CGFloat {
        return position.y
    }
}
