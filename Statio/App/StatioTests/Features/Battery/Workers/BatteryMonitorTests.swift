//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class BatteryMonitorTests: TestCase {

    let interactor = Interactor()
    let mutableBatteryLevelStream = MutableBatteryLevelStreamingMock()
    let mutableBatteryStateStream = MutableBatteryStateStreamingMock()

    var worker: BatteryMonitor!

    override func setUp() {
        super.setUp()
        worker = .init(mutableBatteryLevelStream: mutableBatteryLevelStream,
                       mutableBatteryStateStream: mutableBatteryStateStream)
        interactor.activate()
    }

    func test_newLevel_publishesToStream() {
        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 0)
        worker.start(on: interactor)
        NotificationCenter.default.post(name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 1)
    }

    func test_newState_publishesToStream() {
        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 0)
        worker.start(on: interactor)
        NotificationCenter.default.post(name: UIDevice.batteryStateDidChangeNotification, object: nil)
        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 1)
    }

}
