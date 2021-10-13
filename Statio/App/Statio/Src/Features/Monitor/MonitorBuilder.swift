//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol MonitorDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
    var batteryProvider: BatteryProviding { get }
    var diskProvider: DiskProviding { get }
    var memoryProvider: MemoryProviding { get }
    var processorProvider: ProcessorProviding { get }
}

class MonitorComponent: Component<MonitorDependency> {

    // MARK: - PublishedDependencies

    var monitorTitleProvider: MonitorTitleProviding {
        MonitorTitleProvider()
    }

    var monitorIconProvider: MonitorIconProviding {
        MonitorIconProvider()
    }

    var batteryLevelStream: BatteryLevelStreaming {
        mutableBatteryLevelStream
    }

    var batteryStateStream: BatteryStateStreaming {
        mutableBatteryStateStream
    }

    var diskSnapshotStream: DiskSnapshotStreaming {
        mutableDiskSnapshotStream
    }

    var memorySnapshotStream: MemorySnapshotStreaming {
        mutableMemorySnapshotStream
    }

    var processorSnapshotStream: ProcessorSnapshotStreaming {
        mutableProcessorSnapshotStream
    }

    // MARK: - Internal Dependencies

    fileprivate var batteryMonitorWorker: BatteryMonitorWorking {
        BatteryMonitorWorker(batteryProvider: dependency.batteryProvider,
                             mutableBatteryLevelStream: mutableBatteryLevelStream,
                             mutableBatteryStateStream: mutableBatteryStateStream)
    }

    fileprivate var diskMonitorWorker: DiskMonitorWorking {
        DiskMonitorWorker(diskProvider: dependency.diskProvider,
                          mutableDiskSnapshotStream: mutableDiskSnapshotStream)
    }

    fileprivate var memoryMonitorWorker: MemoryMonitorWorking {
        MemoryMonitorWorker(memoryProvider: dependency.memoryProvider,
                            mutableMemorySnapshotStream: mutableMemorySnapshotStream)
    }

    fileprivate var processorMonitorWorker: ProcessorMonitorWorking {
        ProcessorMonitorWorker(processorProvider: dependency.processorProvider,
                               mutableProcessorSnapshotStream: mutableProcessorSnapshotStream)
    }

    // MARK: - Private Dependencies

    private var mutableBatteryLevelStream: MutableBatteryLevelStreaming {
        shared { BatteryLevelStream() }
    }

    private var mutableBatteryStateStream: MutableBatteryStateStreaming {
        shared { BatteryStateStream() }
    }

    private var mutableDiskSnapshotStream: MutableDiskSnapshotStreaming {
        shared { DiskSnapshotStream() }
    }

    private var mutableMemorySnapshotStream: MutableMemorySnapshotStreaming {
        shared { MemorySnapshotStream() }
    }

    private var mutableProcessorSnapshotStream: MutableProcessorSnapshotStreaming {
        shared { ProcessorSnapshotStream() }
    }

    // MARK: - Children

    fileprivate var monitorListBuilder: MonitorListBuildable {
        MonitorListBuilder { MonitorListComponent(parent: self) }
    }

    fileprivate var deviceIdentityBuilder: DeviceIdentityBuildable {
        DeviceIdentityBuilder { DeviceIdentityComponent(parent: self) }
    }

    fileprivate var memoryBuilder: MemoryBuildable {
        MemoryBuilder { MemoryComponent(parent: self) }
    }

    fileprivate var batteryBuilder: BatteryBuildable {
        BatteryBuilder { BatteryComponent(parent: self) }
    }

    fileprivate var diskBuilder: DiskBuildable {
        DiskBuilder { DiskComponent(parent: self) }
    }

    fileprivate var processorBuilder: ProcessorBuildable {
        ProcessorBuilder { ProcessorComponent(parent: self) }
    }

    fileprivate var cellularBuilder: CellularBuildable {
        CellularBuilder { CellularComponent(parent: self) }
    }

    fileprivate var wifiBuilder: WiFiBuildable {
        WiFiBuilder { WiFiComponent(parent: self) }
    }
}

/// @CreateMock
protocol MonitorInteractable: PresentableInteractable, MonitorListListener, DeviceIdentityListener, MemoryListener, BatteryListener, DiskListener, ProcessorListener, CellularListener, WiFiListener {}

typealias MonitorDynamicBuildDependency = (
    MonitorListener
)

/// @CreateMock
protocol MonitorBuildable: AnyObject {
    func build(withListener listener: MonitorListener) -> PresentableInteractable
}

final class MonitorBuilder: ComponentizedBuilder<MonitorComponent, PresentableInteractable, MonitorDynamicBuildDependency, Void>, MonitorBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MonitorComponent, _ dynamicBuildDependency: MonitorDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MonitorViewController(analyticsManager: component.analyticsManager)
        let interactor = MonitorInteractor(presenter: viewController,
                                           batteryMonitorWorker: component.batteryMonitorWorker,
                                           diskMonitorWorker: component.diskMonitorWorker,
                                           memoryMonitorWorker: component.memoryMonitorWorker,
                                           processorMonitorWorker: component.processorMonitorWorker,
                                           monitorListBuilder: component.monitorListBuilder,
                                           deviceIdentityBuilder: component.deviceIdentityBuilder,
                                           memoryBuilder: component.memoryBuilder,
                                           batteryBuilder: component.batteryBuilder,
                                           diskBuilder: component.diskBuilder,
                                           processorBuilder: component.processorBuilder,
                                           cellularBuilder: component.cellularBuilder,
                                           wifiBuilder: component.wifiBuilder)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MonitorBuildable

    func build(withListener listener: MonitorListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
