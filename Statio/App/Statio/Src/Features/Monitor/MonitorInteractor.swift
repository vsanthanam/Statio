//
// Statio
// Varun Santhanam
//

import Foundation
import Logging
import ShortRibs

/// @CreateMock
protocol MonitorPresentable: MonitorViewControllable {
    var listener: MonitorPresentableListener? { get set }
    func showList(_ monitorList: MonitorListViewControllable)
    func showMonitor(_ viewController: ViewControllable)
}

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
         wifiBuilder: WiFiBuildable,
         accelerometerBuilder: AccelerometerBuildable,
         gyroscopeBuilder: GyroscopeBuildable,
         magnometerBuilder: MagnometerBuildable) {
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
        self.accelerometerBuilder = accelerometerBuilder
        self.gyroscopeBuilder = gyroscopeBuilder
        self.magnometerBuilder = magnometerBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

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
        let monitor: PresentableInteractable
        switch identifier {
        case .identity:
            monitor = deviceIdentityBuilder.build(withListener: self)
        case .memory:
            monitor = memoryBuilder.build(withListener: self)
        case .battery:
            monitor = batteryBuilder.build(withListener: self)
        case .disk:
            monitor = diskBuilder.build(withListener: self)
        case .processor:
            monitor = processorBuilder.build(withListener: self)
        case .cellular:
            monitor = cellularBuilder.build(withListener: self)
        case .wifi:
            monitor = wifiBuilder.build(withListener: self)
        case .accelerometer:
            monitor = accelerometerBuilder.build(withListener: self)
        case .gyroscope:
            monitor = gyroscopeBuilder.build(withListener: self)
        case .magnometer:
            monitor = magnometerBuilder.build(withListener: self)
        default:
            fatalError()
        }

        attach(child: monitor)
        presenter.showMonitor(monitor.viewControllable)
        activeMonitor = monitor
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

    // MARK: - AccelerometerListener

    func accelerometerDidClose() {
        attachMonitorList()
    }

    // MARK: - GyroscopeListener

    func gyroscopeDidClose() {
        attachMonitorList()
    }

    // MARK: - MagnometerListener

    func magnometerDidClose() {
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
    private let accelerometerBuilder: AccelerometerBuildable
    private let gyroscopeBuilder: GyroscopeBuildable
    private let magnometerBuilder: MagnometerBuildable

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
