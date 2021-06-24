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
    let monitorBuilder = MonitorBuildableMock()

    let listener = MainListenerMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           mainDeviceModelStorageWorker: mainDeviceModelStorageWorker,
                           mainDeviceModelUpdateWorker: mainDeviceModelUpdateWorker,
                           monitorBuilder: monitorBuilder)
        interactor.listener = listener
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_startsDeviceModelStorageWorker() {
        mainDeviceModelUpdateWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceModelStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceModelStorageWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceUpdateStorageWorker() {
        mainDeviceModelUpdateWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(mainDeviceModelUpdateWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(mainDeviceModelUpdateWorker.startCallCount, 1)
    }

    func test_activate_attachesMonitor() {
        let monitor = PresentableInteractableMock()
        let viewController = ViewControllableMock()
        monitor.viewControllable = viewController

        monitorBuilder.buildHandler = { listener in
            XCTAssertTrue(listener === self.interactor)
            return monitor
        }

        presenter.showHandler = { vc in
            XCTAssertTrue(vc === viewController)
        }

        XCTAssertEqual(monitorBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

}
