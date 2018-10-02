import XCTest
@testable import CatcherInTheToilet

class PlayStatusTests: XCTestCase {

    private var status: PlayStatus!
    private var delegate: _Delegate!

    override func setUp() {
        status = PlayStatus()
        delegate = _Delegate(status: status)
        status.appendDelegate(delegate: delegate)
    }

    func testScoreChange() {
        XCTAssertEqual(status.MIN_SCORE, 0)

        status.onShitGot(type: ShitType.normal)
        status.onShitGot(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        for _ in 0...10 {
            status.onShitLost(type: ShitType.normal) // expect no event fired
        }
        status.onShitGot(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        status.onShitGot(type: ShitType.normal)
        XCTAssertEqual(delegate.updatedScores, [1, 2, 1, 0, 1, 0, 1])
        XCTAssertEqual(status.score, 1)
    }

    func testScoreChangeForHardShit() {
        status.onShitGot(type: ShitType.hard)
        status.onShitLost(type: ShitType.hard)
        XCTAssertEqual(delegate.updatedScores, [2, 1])
    }

    func testShitGotLostPlayEvent() {
        status.onShitGot(type: ShitType.normal)
        status.onShitGot(type: ShitType.hard)
        status.onShitLost(type: ShitType.normal)
        status.onShitLost(type: ShitType.hard)
        status.onShitLost(type: ShitType.normal)
        XCTAssertEqual(delegate.occuredEvents.count, 5)

        let events = delegate.occuredEvents
        XCTAssertTrue(events[0] == .gotShit(.normal))
        XCTAssertTrue(events[1] == .gotShit(.hard))
        XCTAssertTrue(events[2] == .lostShit(.normal))
        XCTAssertTrue(events[3] == .lostShit(.hard))
        XCTAssertTrue(events[4] == .lostShit(.normal))
    }

    private class _Delegate: PlayStatusDelegate {
        var occuredEvents: [PlayEvent] = []
        var updatedScores: [Int] = []
        let status: PlayStatusProtocol

        init(status: PlayStatusProtocol) {
            self.status = status
        }

        func onScoreUpdated() {
            updatedScores.append(status.score)
        }

        func onEventOccured(event: PlayEvent) {
            occuredEvents.append(event)
        }
    }
}
