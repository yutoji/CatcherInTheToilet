import XCTest
@testable import CatcherInTheToilet

class EvenRandomLoopIteratorTests: XCTestCase {

    var sample = [Int]([1, 2, 3, -99])
    var it: EvenRandomLoopIterator<Int>!

    override func setUp() {
        it = EvenRandomLoopIterator(sample)
    }

    func testResultOneLoop() {
        var results = [Int]()
        for _ in sample {
            results.append(it.next()!)
        }
        XCTAssertEqual(results.sorted(), sample.sorted())
    }

    func testResultTwoLoop() {
        var results = [Int]()
        for _ in 0..<sample.count*2 {
            results.append(it.next()!)
        }
        XCTAssertEqual(results.count, sample.count * 2)
        XCTAssertEqual(results.sorted(), (sample + sample).sorted())
    }

    func testBlank() {
        it = EvenRandomLoopIterator([Int]())
        XCTAssertNil(it.next())
        XCTAssertNil(it.next())
        XCTAssertNil(it.next())
    }

}
