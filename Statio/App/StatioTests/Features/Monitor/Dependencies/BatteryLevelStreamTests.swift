//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import StatioKit
@testable import StatioMocks
import XCTest

final class BatteryLevelStreamTests: TestCase {

    var stream: BatteryLevelStream!

    override func setUp() {
        super.setUp()
        stream = .init()
    }

    func test_update_publishes() {
        var emits = [Battery.Level]()
        stream.batteryLevel
            .sink { value in
                emits.append(value)
            }
            .cancelOnTearDown(testCase: self)
        XCTAssertEqual(emits, [])
        stream.update(level: 0.0)
        XCTAssertEqual(emits, [0.0])
        stream.update(level: 0.5)
        XCTAssertEqual(emits, [0.0, 0.5])
        stream.update(level: 1.0)
        XCTAssertEqual(emits, [0.0, 0.5, 1.0])
    }

}
