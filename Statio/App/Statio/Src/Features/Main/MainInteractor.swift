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
         processorMonitorWorker: ProcessorMonitorWorking,
         monitorBuilder: MonitorBuildable,
         reporterBuilder: ReporterBuildable,
         settingsBuilder: SettingsBuildable) {
        self.appStateManager = appStateManager
        self.deviceModelStorageWorker = deviceModelStorageWorker
        self.deviceModelUpdateWorker = deviceModelUpdateWorker
        self.deviceBoardStorageWorker = deviceBoardStorageWorker
        self.deviceBoardUpdateWorker = deviceBoardUpdateWorker
        self.batteryMonitorWorker = batteryMonitorWorker
        self.memoryMonitorWorker = memoryMonitorWorker
        self.diskMonitorWorker = diskMonitorWorker
        self.processorMonitorWorker = processorMonitorWorker
        self.monitorBuilder = monitorBuilder
        self.reporterBuilder = reporterBuilder
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
    private let processorMonitorWorker: ProcessorMonitorWorking

    private let monitorBuilder: MonitorBuildable
    private let reporterBuilder: ReporterBuildable
    private let settingsBuilder: SettingsBuildable

    private lazy var monitor = monitorBuilder.build(withListener: self)
    private lazy var reporter = reporterBuilder.build(withListener: self)
    private lazy var settings = settingsBuilder.build(withListener: self)

    private var currentState: PresentableInteractable?

    private func startObservingAppState() {
        appStateManager.state
            .removeDuplicates()
            .sink(receiveValue: activate)
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
        processorMonitorWorker.start(on: self)
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
            return monitor
        case .reporter:
            return reporter
        case .settings:
            return settings
        }
    }
}
