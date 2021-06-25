//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class MainInteractorTests: TestCase {

    let presenter = MainPresentableMock()
    let mainDeviceModelStorageWorker = MainDeviceModelStorageWorkingMock()
    let mainDeviceModelUpdateWorker = MainDeviceModelUpdateWorkingMock()
    let mainDeviceBoardStorageWorker = MainDeviceBoardStorageWorkingMock()
    let mainDeviceBoardUpdateWorker = MainDeviceBoardUpdateWorkingMock()

    let listener = MainListenerMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           mainDeviceModelStorageWorker: mainDeviceModelStorageWorker,
                           mainDeviceModelUpdateWorker: mainDeviceModelUpdateWorker,
                           mainDeviceBoardStorageWorker: mainDeviceBoardStorageWorker,
                           mainDeviceBoardUpdateWorker: mainDeviceBoardUpdateWorker)
        interactor.listener = listener
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_startsDeviceModelStorageWorker() {
        mainDeviceModelStorageWorker.startHandler = { [mainDeviceModelUpdateWorker, interactor] scope in
            XCTAssertEqual(mainDeviceModelUpdateWorker.startCallCount, 0)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceModelStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceModelStorageWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceUpdateStorageWorker() {
        mainDeviceModelUpdateWorker.startHandler = { [mainDeviceModelStorageWorker, interactor] scope in
            XCTAssertEqual(mainDeviceModelStorageWorker.startCallCount, 1)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceModelUpdateWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceModelUpdateWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceBoardStorageWorker() {
        mainDeviceBoardStorageWorker.startHandler = { [mainDeviceBoardUpdateWorker, interactor] scope in
            XCTAssertEqual(mainDeviceBoardUpdateWorker.startCallCount, 0)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceBoardStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceBoardStorageWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceBoardUpsateWorker() {
        mainDeviceBoardUpdateWorker.startHandler = { [mainDeviceBoardStorageWorker, interactor] scope in
            XCTAssertEqual(mainDeviceBoardStorageWorker.startCallCount, 1)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceBoardUpdateWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceBoardUpdateWorker.startCallCount, 1)
    }
}
