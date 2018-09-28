import UIKit

class RandomShitStartPositionGainable: ShitStartPositionGainable {

    private let assesItrator: EvenRandomLoopIterator<PositionSizeGettable>

    init(asses: [PositionSizeGettable]) {
        assesItrator = EvenRandomLoopIterator(asses)
    }

    func gain(ofShit shit: SizeGettable) -> CGPoint {
        guard let ass = assesItrator.next() else { return .zero }
        let shitPosition = CGPoint(
            x: ass.x,
            y: ass.y - ass.height / 2 - shit.height / 2
        )
        return shitPosition
    }
}

