import XCTest
@testable import CatcherInTheToilet

class TouchPointCatcherPositionerTests: XCTestCase {

    private let DEFAULT_POSITION = CGPoint(x: 3, y: 111)
    private let SAMPLE_POSITION = CGPoint(x: 8, y: 9)
    fileprivate var catcher: _Catcher!
    private var positioner: TouchPointCatcherPositioner!

    override func setUp() {
        reset()
    }

    private func reset() {
        catcher = _Catcher()
        catcher.position = DEFAULT_POSITION
        positioner = TouchPointCatcherPositioner()
        positioner.setup(catcher: catcher)
    }

    func testWithoutTouch() {
        XCTAssertEqual(positioner.nextPosition, DEFAULT_POSITION)
    }

    func testAfterTouch() {
        positioner.onTouch(touch: SAMPLE_POSITION)
        XCTAssertEqual(positioner.nextPosition, CGPoint(x: 8, y: 111))
    }

    func testAfterTouchEnd() {
        positioner.onTouchEnd()
        XCTAssertEqual(positioner.nextPosition, DEFAULT_POSITION)

        reset()
        positioner.onTouch(touch: SAMPLE_POSITION)
        positioner.onTouchEnd()
        XCTAssertEqual(positioner.nextPosition, CGPoint(x: 8, y: 111))
    }

}

fileprivate class _Catcher: PositionGettable {
    var position: CGPoint = .zero
}
