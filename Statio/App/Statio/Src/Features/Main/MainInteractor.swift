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
         mainDeviceModelStorageWorker: MainDeviceModelStorageWorking,
         mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking,
         mainDeviceBoardStorageWorker: MainDeviceBoardStorageWorking,
         mainDeviceBoardUpdateWorker: MainDeviceBoardUpdateWorking,
         monitorBuilder: MonitorBuildable,
         settingsBuilder: SettingsBuildable) {
        self.appStateManager = appStateManager
        self.mainDeviceModelStorageWorker = mainDeviceModelStorageWorker
        self.mainDeviceModelUpdateWorker = mainDeviceModelUpdateWorker
        self.mainDeviceBoardStorageWorker = mainDeviceBoardStorageWorker
        self.mainDeviceBoardUpdateWorker = mainDeviceBoardUpdateWorker
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

    override func willResignActive() {
        super.willResignActive()
    }

    // MARK: - MainPresentableListener

    func didSelectTab(withTag tag: Int) {
        guard let state = AppState.allCases.first(where: { $0.id == tag }) else {
            loggedAssertionFailure("Selected tab with no applicable app state!", key: "main_interactor_couldnt_find_app_state")
            return
        }
        appStateManager.update(state: state)
    }

    // MARK: - Private

    private let appStateManager: AppStateManaging
    private let mainDeviceModelStorageWorker: MainDeviceModelStorageWorking
    private let mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking
    private let mainDeviceBoardStorageWorker: MainDeviceBoardStorageWorking
    private let mainDeviceBoardUpdateWorker: MainDeviceBoardUpdateWorking
    private let monitorBuilder: MonitorBuildable
    private let settingsBuilder: SettingsBuildable

    private var monitor: PresentableInteractable?
    private var settings: PresentableInteractable?

    private var currentState: PresentableInteractable?

    private func startObservingAppState() {
        appStateManager.state
            .sink { state in
                self.activate(state)
            }
            .cancelOnDeactivate(interactor: self)
    }

    private func configureStates() {
        presenter.showTabs(AppState.allCases.map(\.viewModel))
    }

    private func startWorkers() {
        mainDeviceModelStorageWorker.start(on: self)
        mainDeviceBoardStorageWorker.start(on: self)
        mainDeviceModelUpdateWorker.start(on: self)
        mainDeviceBoardUpdateWorker.start(on: self)
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
            let monitor = monitorBuilder.build(withListener: self)
            self.monitor = monitor
            return monitor
        case .settings:
            if let settings = settings {
                return settings
            }
            let settings = settingsBuilder.build(withListener: self)
            self.settings = settings
            return settings
        }
    }
}
