//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class MonitorInteractorTests: TestCase {

    let presenter = MonitorPresentableMock()
    let listener = MonitorListenerMock()
    let batteryMonitorWorker = BatteryMonitorWorkingMock()
    let diskMonitorWorker = DiskMonitorWorkingMock()
    let memoryMonitorWorker = MemoryMonitorWorkingMock()
    let processorMonitorWorker = ProcessorMonitorWorkingMock()
    let monitorListBuilder = MonitorListBuildableMock()
    let deviceIdentityBuilder = DeviceIdentityBuildableMock()
    let memoryBuilder = MemoryBuildableMock()
    let batteryBuilder = BatteryBuildableMock()
    let diskBuilder = DiskBuildableMock()
    let processorBuilder = ProcessorBuildableMock()
    let cellularBuilder = CellularBuildableMock()

    var interactor: MonitorInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           batteryMonitorWorker: batteryMonitorWorker,
                           diskMonitorWorker: diskMonitorWorker,
                           memoryMonitorWorker: memoryMonitorWorker,
                           processorMonitorWorker: processorMonitorWorker,
                           monitorListBuilder: monitorListBuilder,
                           deviceIdentityBuilder: deviceIdentityBuilder,
                           memoryBuilder: memoryBuilder,
                           batteryBuilder: batteryBuilder,
                           diskBuilder: diskBuilder,
                           processorBuilder: processorBuilder,
                           cellularBuilder: cellularBuilder)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_startsBatteryMonitorWorker() {
        batteryMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(batteryMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(batteryMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsDiskMonitorWorker() {
        diskMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(diskMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(diskMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsMemoryMonitorWorker() {
        memoryMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(memoryMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(memoryMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsProcessorMonitorWorker() {
        processorMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(processorMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(processorMonitorWorker.startCallCount, 1)
    }

    func test_activate_buildsAndPresents_monitorList() {
        monitorListBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return MonitorListInteractableMock()
        }

        XCTAssertEqual(monitorListBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showListCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorListBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showListCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_deviceIdentity_buildsAttachesAndPresents() {
        let viewController = ViewControllableMock()
        let deviceIdentity = PresentableInteractableMock()
        deviceIdentity.viewControllable = viewController

        deviceIdentityBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return deviceIdentity
        }

        XCTAssertEqual(deviceIdentityBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .identity)

        XCTAssertEqual(deviceIdentityBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_memory_buildsAttachesAndPresents() {
        let viewController = ViewControllableMock()
        let memory = PresentableInteractableMock()
        memory.viewControllable = viewController

        memoryBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return memory
        }

        XCTAssertEqual(memoryBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .memory)

        XCTAssertEqual(memoryBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_battery_buildsAndAttaches() {
        let viewController = ViewControllableMock()
        let battery = PresentableInteractableMock()
        battery.viewControllable = viewController

        batteryBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return battery
        }

        XCTAssertEqual(batteryBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .battery)

        XCTAssertEqual(batteryBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_disk_buildsAndAttaches() {
        let viewController = ViewControllableMock()
        let disk = PresentableInteractableMock()
        disk.viewControllable = viewController

        diskBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return disk
        }

        XCTAssertEqual(diskBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .disk)

        XCTAssertEqual(diskBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_processor_buildsAndAttaches() {
        let viewController = ViewControllableMock()
        let processor = PresentableInteractableMock()
        processor.viewControllable = viewController

        processorBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return processor
        }

        XCTAssertEqual(processorBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .processor)

        XCTAssertEqual(processorBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_cellular_buildsAndAttaches() {
        let viewController = ViewControllableMock()
        let cellular = PresentableInteractableMock()
        cellular.viewControllable = viewController

        processorBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return cellular
        }

        XCTAssertEqual(cellularBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        interactor.monitorListDidSelect(identifier: .cellular)

        XCTAssertEqual(cellularBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }
}
