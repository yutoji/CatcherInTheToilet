import XCTest
@testable import CatcherInTheToilet

class RandomShitStartPositionGainableTests: XCTestCase {

    let sampleAsses: [PositionSizeGettable] = [
        StubPositionSizeGettable(x: 33, y: 19, width: 92, height: 32),
        StubPositionSizeGettable(x: 41, y: 28, width: 14, height: 24),
    ]
    let sampleShit: SizeGettable = StubPositionSizeGettable(x: 0, y: 0, width: 10, height: 8)
    var gainer: RandomShitStartPositionGainable!

    override func setUp() {
        gainer = RandomShitStartPositionGainable(asses: sampleAsses)
    }

    func testGain() {
        var shitPositions = [
            gainer.gain(ofShit: sampleShit),
            gainer.gain(ofShit: sampleShit)
        ]
        shitPositions.sort(by: {$0.x < $1.x})
        let expects = [
            CGPoint(x: 33, y: 19 - 32 / 2 - 8 / 2),
            CGPoint(x: 41, y: 28 - 24 / 2 - 8 / 2),
        ]
        XCTAssertEqual(shitPositions, expects)
    }

}
