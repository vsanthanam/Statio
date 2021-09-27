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
    let appStateSubject = PassthroughSubject<AppState, Never>()
    let appStateManager = AppStateManagingMock()
    let deviceModelStorageWorker = DeviceModelStorageWorkingMock()
    let deviceModelUpdateWorker = DeviceModelUpdateWorkingMock()
    let deviceBoardStorageWorker = DeviceBoardStorageWorkingMock()
    let deviceBoardUpdateWorker = DeviceBoardUpdateWorkingMock()
    let batteryMonitorWorker = BatteryMonitorWorkingMock()
    let memoryMonitorWorker = MemoryMonitorWorkingMock()
    let diskMonitorWorker = DiskMonitorWorkingMock()
    let processorMonitorWorker = ProcessorMonitorWorkingMock()
    let monitorBuilder = MonitorBuildableMock()
    let settingsBuilder = SettingsBuildableMock()

    let listener = MainListenerMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        appStateManager.state = appStateSubject.eraseToAnyPublisher()
        interactor = .init(presenter: presenter,
                           appStateManager: appStateManager,
                           deviceModelStorageWorker: deviceModelStorageWorker,
                           deviceModelUpdateWorker: deviceModelUpdateWorker,
                           deviceBoardStorageWorker: deviceBoardStorageWorker,
                           deviceBoardUpdateWorker: deviceBoardUpdateWorker,
                           batteryMonitorWorker: batteryMonitorWorker,
                           memoryMonitorWorker: memoryMonitorWorker,
                           diskMonitorWorker: diskMonitorWorker,
                           processorMonitorWorker: processorMonitorWorker,
                           monitorBuilder: monitorBuilder,
                           settingsBuilder: settingsBuilder)
        interactor.listener = listener
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_configuresStates() {
        presenter.showTabsHandler = { models in
            XCTAssertEqual(models, AppState.allCases.map(\.viewModel))
        }
        XCTAssertEqual(presenter.showTabsCallCount, 0)
        interactor.activate()
        XCTAssertEqual(presenter.showTabsCallCount, 1)
    }

    func test_activate_updatesToInitialState() {
        appStateManager.updateHandler = { state in
            XCTAssertEqual(state, .monitor)
        }
        XCTAssertEqual(appStateManager.updateCallCount, 0)
        interactor.activate()
        XCTAssertEqual(appStateManager.updateCallCount, 1)
    }

    func test_stateSwitchching_buildsOnce_presents_attaches() {
        let monitor = MonitorInteractableMock()
        let settings = SettingsInteractableMock()

        monitorBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return monitor
        }

        settingsBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return settings
        }

        XCTAssertEqual(monitorBuilder.buildCallCount, 0)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorBuilder.buildCallCount, 0)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.monitor.id, id)
        }

        appStateSubject.send(.monitor)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 1)
        XCTAssertEqual(presenter.activateTabCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === monitor)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.settings.id, id)
        }

        appStateSubject.send(.settings)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.embedCallCount, 2)
        XCTAssertEqual(presenter.activateTabCallCount, 2)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === settings)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.monitor.id, id)
        }

        appStateSubject.send(.monitor)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.embedCallCount, 3)
        XCTAssertEqual(presenter.activateTabCallCount, 3)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === monitor)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.settings.id, id)
        }

        appStateSubject.send(.settings)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.embedCallCount, 4)
        XCTAssertEqual(presenter.activateTabCallCount, 4)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === settings)
    }

    func test_didTap_activatesState() {
        XCTAssertEqual(appStateManager.updateCallCount, 0)

        appStateManager.updateHandler = { state in
            XCTAssertEqual(state, .settings)
        }

        interactor.didSelectTab(withTag: AppState.settings.id)

        XCTAssertEqual(appStateManager.updateCallCount, 1)

        appStateManager.updateHandler = { state in
            XCTAssertEqual(state, .monitor)
        }

        interactor.didSelectTab(withTag: AppState.monitor.id)

        XCTAssertEqual(appStateManager.updateCallCount, 2)
    }

    func test_activate_startsDeviceModelStorageWorker() {
        deviceModelStorageWorker.startHandler = { [deviceModelUpdateWorker, interactor] scope in
            XCTAssertEqual(deviceModelUpdateWorker.startCallCount, 0)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(deviceModelStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(deviceModelStorageWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceUpdateStorageWorker() {
        deviceModelUpdateWorker.startHandler = { [deviceModelStorageWorker, interactor] scope in
            XCTAssertEqual(deviceModelStorageWorker.startCallCount, 1)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(deviceModelUpdateWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(deviceModelUpdateWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceBoardStorageWorker() {
        deviceBoardStorageWorker.startHandler = { [deviceBoardUpdateWorker, interactor] scope in
            XCTAssertEqual(deviceBoardUpdateWorker.startCallCount, 0)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(deviceBoardStorageWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(deviceBoardStorageWorker.startCallCount, 1)
    }

    func test_activate_startsDeviceBoardUpsateWorker() {
        deviceBoardUpdateWorker.startHandler = { [deviceBoardStorageWorker, interactor] scope in
            XCTAssertEqual(deviceBoardStorageWorker.startCallCount, 1)
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(deviceBoardUpdateWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(deviceBoardUpdateWorker.startCallCount, 1)
    }

    func test_activate_startsBatteryMonitorWorker() {
        batteryMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(batteryMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(batteryMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsMemoryMonitorWorker() {
        memoryMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(memoryMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(memoryMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsDiskMonitorWorker() {
        diskMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(diskMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(diskMonitorWorker.startCallCount, 1)
    }

    func test_activate_startsProcessorMonitorWorker() {
        processorMonitorWorker.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(processorMonitorWorker.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(processorMonitorWorker.startCallCount, 1)
    }
}
