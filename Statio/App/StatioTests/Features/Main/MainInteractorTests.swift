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
    let mainDeviceModelStorageWorker = MainDeviceModelStorageWorkingMock()
    let mainDeviceModelUpdateWorker = MainDeviceModelUpdateWorkingMock()
    let mainDeviceBoardStorageWorker = MainDeviceBoardStorageWorkingMock()
    let mainDeviceBoardUpdateWorker = MainDeviceBoardUpdateWorkingMock()
    let monitorBuilder = MonitorBuildableMock()
    let settingsBuilder = SettingsBuildableMock()

    let listener = MainListenerMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        appStateManager.state = appStateSubject.eraseToAnyPublisher()
        interactor = .init(presenter: presenter,
                           appStateManager: appStateManager,
                           mainDeviceModelStorageWorker: mainDeviceModelStorageWorker,
                           mainDeviceModelUpdateWorker: mainDeviceModelUpdateWorker,
                           mainDeviceBoardStorageWorker: mainDeviceBoardStorageWorker,
                           mainDeviceBoardUpdateWorker: mainDeviceBoardUpdateWorker,
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

        monitor.activateHandler = { monitor.isActive = true }
        monitor.deactivateHandler = { monitor.isActive = false }

        settings.activateHandler = { settings.isActive = true }
        settings.deactivateHandler = { settings.isActive = false }

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
