import XCTest
@testable import MehHTTP

final class MehHTTPTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MehHTTP().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
