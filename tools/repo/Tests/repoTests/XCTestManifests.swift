//
// Statio
// Varun Santhanam
//

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(repoTests.allTests)
        ]
    }
#endif
