//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MonitorPresentable: MonitorViewControllable {
    var listener: MonitorPresentableListener? { get set }
    func showList(_ monitorList: MonitorListViewControllable)
    func showMonitor(_ viewController: ViewControllable)
}

/// @mockable
protocol MonitorListener: AnyObject {}

final class MonitorInteractor: PresentableInteractor<MonitorPresentable>, MonitorInteractable, MonitorPresentableListener {

    // MARK: - Initializers

    init(presenter: MonitorPresentable,
         monitorListBuilder: MonitorListBuildable,
         deviceIdentityBuilder: DeviceIdentityBuildable,
         memoryBuilder: MemoryBuildable) {
        self.monitorListBuilder = monitorListBuilder
        self.deviceIdentityBuilder = deviceIdentityBuilder
        self.memoryBuilder = memoryBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MonitorListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        if activeMonitor == nil {
            attachMonitorList()
        }
    }

    // MARK: - MonitorListListener

    func monitorListDidSelect(identifier: MonitorIdentifier) {
        if let monitorList = monitorList {
            detach(child: monitorList)
        }
        if let activeMonitor = activeMonitor {
            detach(child: activeMonitor)
        }
        switch identifier {
        case .identity:
            let monitor = deviceIdentityBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        case .memory:
            let monitor = memoryBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        default:
            fatalError()
        }
    }

    // MARK: - DeviceIdentityListener

    func deviceIdentityDidClose() {
        attachMonitorList()
    }

    // MARK: - Private

    private let monitorListBuilder: MonitorListBuildable
    private let deviceIdentityBuilder: DeviceIdentityBuildable
    private let memoryBuilder: MemoryBuildable

    private var monitorList: MonitorListInteractable?
    private var activeMonitor: PresentableInteractable?

    private func attachMonitorList() {
        if let activeMonitor = activeMonitor {
            detach(child: activeMonitor)
        }
        let monitorList = self.monitorList ?? monitorListBuilder.build(withListener: self)
        attach(child: monitorList)
        presenter.showList(monitorList.viewController)
        self.monitorList = monitorList
    }
}
