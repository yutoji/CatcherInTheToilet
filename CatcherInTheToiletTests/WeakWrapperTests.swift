import XCTest
@testable import CatcherInTheToilet

class WeakWrapperTests: XCTestCase {

    func testWeakness() {
        var object: Example = Example()
        let weakWrapper = WeakWrapper<Example>(object)
        XCTAssertNotNil(weakWrapper.object)
        XCTAssertEqual(weakWrapper.object, object)

        object = Example()
        XCTAssertNil(weakWrapper.object)
    }

    class Example: Equatable {
        let id = UUID().uuidString
        static func == (lhs: WeakWrapperTests.Example, rhs: WeakWrapperTests.Example) -> Bool {
            return lhs.id == rhs.id
        }
    }

}

