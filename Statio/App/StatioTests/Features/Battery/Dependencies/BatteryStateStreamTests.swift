//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class BatteryStateStreamTests: TestCase {

    var stream: BatteryStateStream!

    override func setUp() {
        super.setUp()
        stream = .init()
    }

    func test_update_publishes() {
        var emits = [BatteryState]()
        stream.batteryState
            .sink { value in
                emits.append(value)
            }
            .cancelOnTearDown(testCase: self)
        XCTAssertEqual(emits, [])
        stream.update(batteryState: .discharging)
        XCTAssertEqual(emits, [.discharging])
        stream.update(batteryState: .charging)
        XCTAssertEqual(emits, [.discharging, .charging])
        stream.update(batteryState: .full)
        XCTAssertEqual(emits, [.discharging, .charging, .full])
    }

}
