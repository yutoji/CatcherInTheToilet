import XCTest
@testable import CatcherInTheToilet

class CommentStreamLogicTests: XCTestCase {

    var screenWidth: CGFloat! // default 400
    var timeSpan: TimeInterval! // default 1.0
    var logic: CommentStreamLogic!
    var preceeding: CommentStreamLogicItem! // default width 200
    var succeeding: CommentStreamLogicItem!

    override func setUp() {
        _setupLogic()
    }

    private func _setupLogic(screenWidth: CGFloat = 400, timeSpan: TimeInterval = 1.0) {
        self.screenWidth = screenWidth
        self.timeSpan = timeSpan
        logic = CommentStreamLogic(screenWidth: screenWidth, streamTimeSpan: timeSpan)
        self.preceeding = _makeComment(width: 200, timeDiffRatio: 0)
    }

    func testPoint() {
        var segment = (from: CGPoint(x: 0, y: 0), to: CGPoint(x: 1, y: 1))

        var point = CommentStreamLogic.point(onWhichSegment: segment, ofX: 0.5)
        XCTAssertEqual(point, CGPoint(x: 0.5, y: 0.5))

        point = CommentStreamLogic.point(onWhichSegment: segment, ofX: 0.6)
        XCTAssertEqual(point, CGPoint(x: 0.6, y: 0.6))

        segment = (from: CGPoint(x: -1, y: -1), to: CGPoint(x: 1, y: 1))
        point = CommentStreamLogic.point(onWhichSegment: segment, ofX: 0.5)
        XCTAssertEqual(point, CGPoint(x: 0.5, y: 0.5))

        //reverse +-
        segment = (from: CGPoint(x: 1, y: 1), to: CGPoint(x: -1, y: -1))
        point = CommentStreamLogic.point(onWhichSegment: segment, ofX: 0.5)
        XCTAssertEqual(point, CGPoint(x: 0.5, y: 0.5))

        segment = (from: CGPoint(x: 1, y: 1), to: CGPoint(x: -1, y: -1))
        point = CommentStreamLogic.point(onWhichSegment: segment, ofX: -0.5)
        XCTAssertEqual(point, CGPoint(x: -0.5, y: -0.5))
    }


    func testOverSpan() {
        succeeding = _makeComment(width:1000, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width: 200, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width:   2, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width:1000, timeDiffRatio: 2.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width: 200, timeDiffRatio: 2.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width:   2, timeDiffRatio: 2.0)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width:1000, timeDiffRatio: 100.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width: 200, timeDiffRatio: 100.0)
        XCTAssertFalse(_willColid())
        succeeding = _makeComment(width:   2, timeDiffRatio: 100.0)
        XCTAssertFalse(_willColid())
    }

    func toDouble(double: Double) -> Double {
        return double
    }

    func testSameTimeStream() {
        succeeding = _makeComment(width: 200, timeDiffRatio: 0)

        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 2, timeDiffRatio: 0)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 0)
        XCTAssertTrue(_willColid())
    }

    func testSameSize() {
        succeeding = _makeComment(width: 200, timeDiffRatio: 0)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 200, timeDiffRatio: 0.2)
        XCTAssertTrue(_willColid())

        // border here

        succeeding = _makeComment(width: 200, timeDiffRatio: 0.4)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 200, timeDiffRatio: 0.6)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 200, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 200, timeDiffRatio: 1.1)
        XCTAssertFalse(_willColid())
    }

    func testTooSmall() { // too small means too speedy
        succeeding = _makeComment(width: 1, timeDiffRatio: 0)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 1, timeDiffRatio: 0.2)
        XCTAssertTrue(_willColid())

        // border is 200/600 == 0.333...
        // because the slant is (width) / (width + screen.width)

        succeeding = _makeComment(width: 1, timeDiffRatio: 0.4)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 1, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 1, timeDiffRatio: 1.1)
        XCTAssertFalse(_willColid())
    }

    func testTooLarge() {
        succeeding = _makeComment(width: 1000, timeDiffRatio: 0)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 0.2)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 0.6)
        XCTAssertTrue(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 0.8)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 1.0)
        XCTAssertFalse(_willColid())

        succeeding = _makeComment(width: 1000, timeDiffRatio: 1.1)
        XCTAssertFalse(_willColid())
    }

    private func _willColid() -> Bool {
        return logic.willCollide(preceding: preceeding, succeeding: succeeding)
    }

    private func _makeComment(width: CGFloat, timeDiffRatio: Double) -> CommentStreamLogicItem {
        let timeDiff = timeSpan * timeDiffRatio
        let startedAt = Date.init(timeIntervalSince1970: timeDiff)
        return CommentStreamLogicItemImpl(width: width, startedAt: startedAt)
    }

}
