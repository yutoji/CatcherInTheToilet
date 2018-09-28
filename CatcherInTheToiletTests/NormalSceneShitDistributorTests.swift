import XCTest
@testable import CatcherInTheToilet

class NormalSceneShitDistributorTests: XCTestCase {

    let START_POSITION: CGPoint = CGPoint(x: 3, y: 99)
    var distributor: SceneShitDistributor!
    var stubTimer: StubGameTimer!
    fileprivate var delegate: _Delegate!

    override func setUp() {
        let positionGainer = StubShitStartPositionGainer()
        positionGainer.stub = START_POSITION
        stubTimer = StubGameTimer()
        distributor = NormalSceneShitDistributor(positionGainable: positionGainer, timer: stubTimer)
        delegate = _Delegate()
        distributor.delegate = delegate
    }

    func testDistribute() {
        XCTAssertEqual(delegate.distributedShits.count, 0)
        distributor.start()
        XCTAssertEqual(delegate.distributedShits.count, 0)
        stubTimer.completion?()
        XCTAssertEqual(delegate.distributedShits.count, 1)
        XCTAssertEqual(delegate.distributedShits[0].position, START_POSITION)

        stubTimer.completion?()
        XCTAssertEqual(delegate.distributedShits.count, 2)
        XCTAssertEqual(delegate.distributedShits[1].position, START_POSITION)

        XCTAssertEqual(stubTimer.calledFuncNames, ["start"])

        distributor.stop()
        XCTAssertEqual(delegate.distributedShits.count, 2)
        XCTAssertEqual(stubTimer.calledFuncNames, ["start", "stop"])

        distributor.stop()
        distributor.stop()
        XCTAssertEqual(delegate.distributedShits.count, 2)
        XCTAssertEqual(stubTimer.calledFuncNames, ["start", "stop", "stop", "stop"])

        distributor.start()
        XCTAssertEqual(stubTimer.calledFuncNames, ["start", "stop", "stop", "stop", "start"])
        stubTimer.completion?()
        XCTAssertEqual(delegate.distributedShits.count, 3)
        XCTAssertEqual(delegate.distributedShits[2].position, START_POSITION)
        XCTAssertEqual(stubTimer.calledFuncNames, ["start", "stop", "stop", "stop", "start"])
    }

    func testDeinit() {
        distributor.start()
        distributor = nil
        XCTAssertEqual(stubTimer.calledFuncNames, ["start", "stop"])
    }
}

fileprivate class _Delegate: SceneShitDistributorDelegate {
    var distributedShits: [ShitNode] = []
    func onDistributed(newShit: ShitNode) {
        distributedShits.append(newShit)
    }
}
