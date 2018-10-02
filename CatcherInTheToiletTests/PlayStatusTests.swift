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
        status.onShitLost(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal) // expect event fired
        status.onShitGot(type: ShitType.normal)
        status.onShitLost(type: ShitType.normal)
        status.onShitGot(type: ShitType.normal)
        XCTAssertEqual(delegate.updatedScores, [3, 2, 1, 0, 0, 3, 2, 5])
        XCTAssertEqual(delegate.updatedScoreDiffs, [3, -1, -1, -1, 0, 3, -1, 3])
        XCTAssertEqual(status.score, 5)
    }

    func testScoreChangeForHardShit() {
        status.onShitGot(type: ShitType.hard)
        status.onShitLost(type: ShitType.hard)
        XCTAssertEqual(delegate.updatedScores, [5, 4])
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
        var updatedScoreDiffs: [Int] = []
        let status: PlayStatusProtocol

        init(status: PlayStatusProtocol) {
            self.status = status
        }

        func onScoreUpdated(diff: Int) {
            updatedScores.append(status.score)
            updatedScoreDiffs.append(diff)
        }

        func onEventOccured(event: PlayEvent) {
            occuredEvents.append(event)
        }
    }
}
