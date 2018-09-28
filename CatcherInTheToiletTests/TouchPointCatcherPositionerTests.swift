import XCTest
@testable import CatcherInTheToilet

class TouchPointCatcherPositionerTests: XCTestCase {

    private let DEFAULT_POSITION = CGPoint(x: 3, y: 111)
    private let SAMPLE_POSITION = CGPoint(x: 8, y: 9)
    fileprivate var catcher: _Catcher!
    private var positioner: TouchPointCatcherPositioner!
    fileprivate var delegate: _Delegate!

    override func setUp() {
        reset()
    }

    private func reset() {
        catcher = _Catcher()
        catcher.position = DEFAULT_POSITION
        positioner = TouchPointCatcherPositioner()
        delegate = _Delegate()
        positioner.setup(catcher: catcher)
        positioner.delegate = delegate
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

    func testDelegate() {
        positioner.onTouch(touch: SAMPLE_POSITION)
        positioner.onTouchEnd()
        XCTAssertEqual(delegate.updatedCount, 0)

        positioner.onFrameUpdated()
        XCTAssertEqual(delegate.updatedCount, 1)

        positioner.onFrameUpdated()
        XCTAssertEqual(delegate.updatedCount, 2)
    }

}

fileprivate class _Catcher: PositionGettable {
    var position: CGPoint = .zero
}

fileprivate class _Delegate: CatcherPositionerDelegate {
    var updatedCount: Int = 0
    func onCatcherPositionUpdated() {
        updatedCount += 1
    }
}
