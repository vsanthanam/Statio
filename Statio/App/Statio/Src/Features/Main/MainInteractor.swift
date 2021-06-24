//
// Statio
// Varun Santhanam
//

import Foundation
import os.log
import ShortRibs
import UIKit

/// @mockable
protocol MainPresentable: MainViewControllable {
    var listener: MainPresentableListener? { get set }
    func show(_ viewController: ViewControllable)
}

/// @mockable
protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    // MARK: - Initializers

    init(presenter: MainPresentable,
         mainDeviceModelStorageWorker: MainDeviceModelStorageWorking,
         mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking,
         monitorBuilder: MonitorBuildable) {
        self.mainDeviceModelStorageWorker = mainDeviceModelStorageWorker
        self.mainDeviceModelUpdateWorker = mainDeviceModelUpdateWorker
        self.monitorBuilder = monitorBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MainListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startWorkers()
        attachMonitor()
    }

    // MARK: - Private

    private let mainDeviceModelStorageWorker: MainDeviceModelStorageWorking
    private let mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking
    private let monitorBuilder: MonitorBuildable

    private var monitor: PresentableInteractable?

    private func startWorkers() {
        mainDeviceModelStorageWorker.start(on: self)
        mainDeviceModelUpdateWorker.start(on: self)
    }

    private func attachMonitor() {
        let monitor = self.monitor ?? monitorBuilder.build(withListener: self)
        attach(child: monitor)
        presenter.show(monitor.viewControllable)
        self.monitor = monitor
    }

}
