import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Swiftz_ValidationTests.allTests),
    ]
}
#endif