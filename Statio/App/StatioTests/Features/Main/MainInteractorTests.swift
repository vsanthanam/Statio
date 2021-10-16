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
    let appStateManager = AppStateManagingMock()
    let deviceModelStorageWorker = DeviceModelStorageWorkingMock()
    let deviceModelUpdateWorker = DeviceModelUpdateWorkingMock()
    let deviceBoardStorageWorker = DeviceBoardStorageWorkingMock()
    let deviceBoardUpdateWorker = DeviceBoardUpdateWorkingMock()
    let monitorBuilder = MonitorBuildableMock()
    let reporterBuilder = ReporterBuildableMock()
    let settingsBuilder = SettingsBuildableMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           appStateManager: appStateManager,
                           deviceModelStorageWorker: deviceModelStorageWorker,
                           deviceModelUpdateWorker: deviceModelUpdateWorker,
                           deviceBoardStorageWorker: deviceBoardStorageWorker,
                           deviceBoardUpdateWorker: deviceBoardUpdateWorker,
                           monitorBuilder: monitorBuilder,
                           reporterBuilder: reporterBuilder,
                           settingsBuilder: settingsBuilder)
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
        let reporter = ReporterInteractableMock()
        let settings = SettingsInteractableMock()

        monitorBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return monitor
        }

        reporterBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return reporter
        }

        settingsBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return settings
        }

        XCTAssertEqual(monitorBuilder.buildCallCount, 0)
        XCTAssertEqual(reporterBuilder.buildCallCount, 0)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorBuilder.buildCallCount, 0)
        XCTAssertEqual(reporterBuilder.buildCallCount, 0)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.monitor.id, id)
        }

        appStateManager.stateSubject.send(.monitor)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(reporterBuilder.buildCallCount, 0)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 1)
        XCTAssertEqual(presenter.activateTabCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === monitor)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.reporter.id, id)
        }

        appStateManager.stateSubject.send(.reporter)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(reporterBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 2)
        XCTAssertEqual(presenter.activateTabCallCount, 2)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === reporter)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.monitor.id, id)
        }

        appStateManager.stateSubject.send(.monitor)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(reporterBuilder.buildCallCount, 1)
        XCTAssertEqual(settingsBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.embedCallCount, 3)
        XCTAssertEqual(presenter.activateTabCallCount, 3)
        XCTAssertEqual(interactor.children.count, 1)
        XCTAssertTrue(interactor.children.first === monitor)

        presenter.activateTabHandler = { id in
            XCTAssertEqual(AppState.settings.id, id)
        }

        appStateManager.stateSubject.send(.settings)

        XCTAssertEqual(monitorBuilder.buildCallCount, 1)
        XCTAssertEqual(reporterBuilder.buildCallCount, 1)
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

        appStateManager.updateHandler = { state in
            XCTAssertEqual(state, .reporter)
        }

        interactor.didSelectTab(withTag: AppState.reporter.id)

        XCTAssertEqual(appStateManager.updateCallCount, 3)
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
}
