import UIKit

protocol PositionSizeGettable: PositionGettable, SizeGettable {
}


class StubPositionSizeGettable: PositionSizeGettable {
    var position: CGPoint = .zero
    var size: CGSize = .zero

    init() {
    }

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        position = CGPoint(x: x, y: y)
        size = CGSize(width: width, height: height)
    }
}
