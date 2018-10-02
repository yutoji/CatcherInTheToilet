import XCTest
@testable import CatcherInTheToilet

class GameTimerTests: XCTestCase {

    let EXPECTATION_TIMEOUT: TimeInterval = 5 // take much seconds
    let INTERVAL: TimeInterval = 0.01
    private var gameTimer: GameTimer!

    override func setUp() {
        gameTimer = GameTimer(interval: INTERVAL, repeats: true)
    }

    func testRepeatsAndStop() {
        let repeatCount = 3
        var completionCount = 0
        gameTimer.completion = {
            completionCount += 1
            XCTAssertTrue(self.gameTimer.isRunning)
            if completionCount == repeatCount {
                self.gameTimer.stop()
                XCTAssertFalse(self.gameTimer.isRunning)
            }
        }
        let repeatExpectation = self.expectation(description: "finish")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2 ) {
            XCTAssertEqual(completionCount, repeatCount)
            XCTAssertFalse(self.gameTimer.isRunning)
            repeatExpectation.fulfill()
        }

        XCTAssertFalse(gameTimer.isRunning)
        gameTimer.start()
        XCTAssertTrue(gameTimer.isRunning)
        self.waitForExpectations(timeout: EXPECTATION_TIMEOUT, handler: nil)
    }

    func testNonRepeats() {
        var calledCount = 0
        gameTimer = GameTimer(interval: INTERVAL, repeats: false)
        let oneTimeFinishExpectation = self.expectation(description: "oneTimeFinishEnough")
        gameTimer.completion = {
            calledCount += 1
            XCTAssertTrue(self.gameTimer.isRunning) // !!!! because this is in the completion sequence
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertFalse(self.gameTimer.isRunning)
            oneTimeFinishExpectation.fulfill()
        }
        XCTAssertFalse(gameTimer.isRunning)
        gameTimer.start()
        self.waitForExpectations(timeout: EXPECTATION_TIMEOUT, handler: nil)
    }

    func testDeinit() {
        var calledCount = 0
        gameTimer.completion = {
            calledCount += 1 // never called
        }
        gameTimer.start()
        gameTimer = nil // deinit will be called
        let waitExpectation = self.expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(calledCount, 0)
            waitExpectation.fulfill()
        }
        self.waitForExpectations(timeout: EXPECTATION_TIMEOUT, handler: nil)
    }
}
