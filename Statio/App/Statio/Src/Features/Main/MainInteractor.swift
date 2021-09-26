//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import os.log
import ShortRibs
import UIKit

/// @mockable
protocol MainPresentable: MainViewControllable {
    var listener: MainPresentableListener? { get set }
    func embed(_ viewController: ViewControllable)
    func showTabs(_ models: [MainTabViewModel])
    func activateTab(_ id: Int)
}

/// @mockable
protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    // MARK: - Initializers

    init(presenter: MainPresentable,
         appStateManager: AppStateManaging,
         deviceModelStorageWorker: DeviceModelStorageWorking,
         deviceModelUpdateWorker: DeviceModelUpdateWorking,
         deviceBoardStorageWorker: DeviceBoardStorageWorking,
         deviceBoardUpdateWorker: DeviceBoardUpdateWorking,
         batteryMonitorWorker: BatteryMonitorWorking,
         memoryMonitorWorker: MemoryMonitorWorking,
         diskMonitorWorker: DiskMonitorWorking,
         monitorBuilder: MonitorBuildable,
         settingsBuilder: SettingsBuildable) {
        self.appStateManager = appStateManager
        self.deviceModelStorageWorker = deviceModelStorageWorker
        self.deviceModelUpdateWorker = deviceModelUpdateWorker
        self.deviceBoardStorageWorker = deviceBoardStorageWorker
        self.deviceBoardUpdateWorker = deviceBoardUpdateWorker
        self.batteryMonitorWorker = batteryMonitorWorker
        self.memoryMonitorWorker = memoryMonitorWorker
        self.diskMonitorWorker = diskMonitorWorker
        self.monitorBuilder = monitorBuilder
        self.settingsBuilder = settingsBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MainListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        configureStates()
        startObservingAppState()
        startWorkers()
        appStateManager.update(state: .monitor)
    }

    // MARK: - MainPresentableListener

    func didSelectTab(withTag tag: Int) {
        guard let state = AppState.allCases.first(where: { state in state.id == tag }) else {
            loggedAssertionFailure("Selected tab with no applicable app state!", key: "main_interactor_couldnt_find_app_state")
            return
        }
        appStateManager.update(state: state)
    }

    // MARK: - Private

    private let appStateManager: AppStateManaging

    private let deviceModelStorageWorker: DeviceModelStorageWorking
    private let deviceModelUpdateWorker: DeviceModelUpdateWorking
    private let deviceBoardStorageWorker: DeviceBoardStorageWorking
    private let deviceBoardUpdateWorker: DeviceBoardUpdateWorking
    private let batteryMonitorWorker: BatteryMonitorWorking
    private let memoryMonitorWorker: MemoryMonitorWorking
    private let diskMonitorWorker: DiskMonitorWorking

    private let monitorBuilder: MonitorBuildable
    private let settingsBuilder: SettingsBuildable

    private var monitor: PresentableInteractable?
    private var settings: PresentableInteractable?

    private var currentState: PresentableInteractable?

    private func startObservingAppState() {
        appStateManager.state
            .removeDuplicates()
            .sink { state in
                self.activate(state)
            }
            .cancelOnDeactivate(interactor: self)
    }

    private func configureStates() {
        presenter.showTabs(AppState.allCases.map(\.viewModel))
    }

    private func startWorkers() {
        deviceModelStorageWorker.start(on: self)
        deviceBoardStorageWorker.start(on: self)
        deviceModelUpdateWorker.start(on: self)
        deviceBoardUpdateWorker.start(on: self)
        batteryMonitorWorker.start(on: self)
        memoryMonitorWorker.start(on: self)
        diskMonitorWorker.start(on: self)
    }

    private func activate(_ appState: AppState) {
        if let currentState = currentState {
            detach(child: currentState)
        }
        let interactor = interactor(for: appState)
        attach(child: interactor)
        presenter.embed(interactor.viewControllable)
        presenter.activateTab(appState.id)
        currentState = interactor
    }

    private func interactor(for appState: AppState) -> PresentableInteractable {
        switch appState {
        case .monitor:
            if let monitor = monitor {
                return monitor
            }
            let monitor = self.monitor ?? monitorBuilder.build(withListener: self)
            self.monitor = monitor
            return monitor
        case .settings:
            if let settings = settings {
                return settings
            }
            let settings = self.settings ?? settingsBuilder.build(withListener: self)
            self.settings = settings
            return settings
        }
    }
}
