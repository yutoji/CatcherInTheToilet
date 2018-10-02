import XCTest
@testable import CatcherInTheToilet

class DelegateContainerTests: XCTestCase {

    var container: DelegateContainer<Example>!

    override func setUp() {
        container = DelegateContainer<Example>()
    }

    func testInitialStater() {
        XCTAssertEqual(container.count(), 0)
        container.forEach() { delegate in
            XCTAssert(false)
        }
    }

    func testWeakness() {
        var object = Example(value: 1)
        container.append(delegate: object)
        object = Example(value: 0)

        container.forEach() { delegate in
            XCTAssert(false)
        }

        XCTAssertEqual(container.count(), 0)
    }

    func testForEach() {
        var objects: [Example] = [Example(value: 1), Example(value: 2)]
        container.append(delegate: objects[0])
        container.append(delegate: objects[1])
        container.forEach() { delegate in
            delegate.delegateCalledCount += 1
        }
        XCTAssertEqual(objects[0].delegateCalledCount, 1)
        XCTAssertEqual(objects[1].delegateCalledCount, 1)

        objects = []
        container.forEach() { delegate in
            delegate.delegateCalledCount += 1
        }
        XCTAssertEqual(container.count(), 0)
    }

    class Example {
        var value: Int
        var delegateCalledCount: Int = 0
        init(value: Int) {
            self.value = value
        }
    }

}
