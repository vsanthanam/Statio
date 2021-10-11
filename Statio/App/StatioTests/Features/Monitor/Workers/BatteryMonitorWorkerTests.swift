//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class BatteryWorkerMonitorTests: TestCase {

    let interactor = Interactor()
    let batteryProvider = BatteryProvidingMock()
    let mutableBatteryLevelStream = MutableBatteryLevelStreamingMock()
    let mutableBatteryStateStream = MutableBatteryStateStreamingMock()

    var worker: BatteryMonitorWorker!

    override func setUp() {
        super.setUp()
        worker = .init(batteryProvider: batteryProvider,
                       mutableBatteryLevelStream: mutableBatteryLevelStream,
                       mutableBatteryStateStream: mutableBatteryStateStream)
        interactor.activate()
        batteryProvider.level = 0.0
        batteryProvider.state = .unknown
    }

    func test_newLevel_publishesToStream() {
        batteryProvider.level = 0.5

        mutableBatteryLevelStream.updateHandler = { level in
            XCTAssertEqual(level, 0.5)
        }

        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 0)

        worker.start(on: interactor)

        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 1)

        NotificationCenter.default.post(name: UIDevice.batteryLevelDidChangeNotification, object: nil)

        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 1)

        batteryProvider.level = 0.6

        mutableBatteryLevelStream.updateHandler = { level in
            XCTAssertEqual(level, 0.6)
        }

        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 1)

        NotificationCenter.default.post(name: UIDevice.batteryLevelDidChangeNotification, object: nil)

        XCTAssertEqual(mutableBatteryLevelStream.updateCallCount, 2)
    }

    func test_newState_publishesToStream() {
        batteryProvider.state = .charging

        mutableBatteryStateStream.updateHandler = { state in
            XCTAssertEqual(state, .charging)
        }

        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 0)

        worker.start(on: interactor)

        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 1)

        NotificationCenter.default.post(name: UIDevice.batteryStateDidChangeNotification, object: nil)

        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 1)

        batteryProvider.state = .discharging

        mutableBatteryStateStream.updateHandler = { state in
            XCTAssertEqual(state, .discharging)
        }

        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 1)

        NotificationCenter.default.post(name: UIDevice.batteryStateDidChangeNotification, object: nil)

        XCTAssertEqual(mutableBatteryStateStream.updateCallCount, 2)
    }

}
