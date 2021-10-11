//
// Statio
// Varun Santhanam
//

import Foundation
import Logging
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
         batteryMonitorWorker: BatteryMonitorWorking,
         diskMonitorWorker: DiskMonitorWorking,
         memoryMonitorWorker: MemoryMonitorWorking,
         processorMonitorWorker: ProcessorMonitorWorking,
         monitorListBuilder: MonitorListBuildable,
         deviceIdentityBuilder: DeviceIdentityBuildable,
         memoryBuilder: MemoryBuildable,
         batteryBuilder: BatteryBuildable,
         diskBuilder: DiskBuildable,
         processorBuilder: ProcessorBuildable,
         cellularBuilder: CellularBuildable,
         wifiBuilder: WiFiBuildable) {
        self.batteryMonitorWorker = batteryMonitorWorker
        self.diskMonitorWorker = diskMonitorWorker
        self.memoryMonitorWorker = memoryMonitorWorker
        self.processorMonitorWorker = processorMonitorWorker
        self.monitorListBuilder = monitorListBuilder
        self.deviceIdentityBuilder = deviceIdentityBuilder
        self.memoryBuilder = memoryBuilder
        self.batteryBuilder = batteryBuilder
        self.diskBuilder = diskBuilder
        self.processorBuilder = processorBuilder
        self.cellularBuilder = cellularBuilder
        self.wifiBuilder = wifiBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MonitorListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startWorkers()
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
        case .battery:
            let monitor = batteryBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        case .disk:
            let monitor = diskBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        case .processor:
            let monitor = processorBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        case .cellular:
            let monitor = cellularBuilder.build(withListener: self)
            attach(child: monitor)
            presenter.showMonitor(monitor.viewControllable)
            activeMonitor = monitor
        case .wifi:
            let monitor = wifiBuilder.build(withListener: self)
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

    // MARK: - MemoryListener

    func memoryDidClose() {
        attachMonitorList()
    }

    // MARK: - BatteryListener

    func batteryDidClose() {
        attachMonitorList()
    }

    // MARK: - DiskListener

    func diskDidClose() {
        attachMonitorList()
    }

    // MARK: - ProcessorListener

    func processorDidClose() {
        attachMonitorList()
    }

    // MARK: - CellularListener

    func cellularDidClose() {
        attachMonitorList()
    }

    // MARK: - WiFiListener

    func wifiDidClose() {
        attachMonitorList()
    }

    // MARK: - Private

    private let batteryMonitorWorker: BatteryMonitorWorking
    private let diskMonitorWorker: DiskMonitorWorking
    private let memoryMonitorWorker: MemoryMonitorWorking
    private let processorMonitorWorker: ProcessorMonitorWorking

    private let monitorListBuilder: MonitorListBuildable
    private let deviceIdentityBuilder: DeviceIdentityBuildable
    private let memoryBuilder: MemoryBuildable
    private let batteryBuilder: BatteryBuildable
    private let diskBuilder: DiskBuildable
    private let processorBuilder: ProcessorBuildable
    private let cellularBuilder: CellularBuildable
    private let wifiBuilder: WiFiBuildable

    private var monitorList: MonitorListInteractable?
    private var activeMonitor: PresentableInteractable?

    private func startWorkers() {
        batteryMonitorWorker.start(on: self)
        diskMonitorWorker.start(on: self)
        memoryMonitorWorker.start(on: self)
        processorMonitorWorker.start(on: self)
    }

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
