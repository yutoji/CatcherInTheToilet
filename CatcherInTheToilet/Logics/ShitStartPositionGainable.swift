import UIKit

protocol ShitStartPositionGainable {
    func gain(ofShit: SizeGettable) -> CGPoint
}

class StubShitStartPositionGainer: ShitStartPositionGainable {
    var stub: CGPoint = .zero
    func gain(ofShit: SizeGettable) -> CGPoint {
        return stub
    }
}
