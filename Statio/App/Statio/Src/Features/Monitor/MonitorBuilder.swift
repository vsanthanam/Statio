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
}

class MonitorComponent: Component<MonitorDependency> {

    // MARK: - PublishedDependencies

    var monitorTitleProvider: MonitorTitleProviding {
        MonitorTitleProvider()
    }

    var monitorIconProvider: MonitorIconProviding {
        MonitorIconProvider()
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
}

/// @mockable
protocol MonitorInteractable: PresentableInteractable, MonitorListListener, DeviceIdentityListener, MemoryListener, BatteryListener, DiskListener, ProcessorListener, CellularListener {}

typealias MonitorDynamicBuildDependency = (
    MonitorListener
)

/// @mockable
protocol MonitorBuildable: AnyObject {
    func build(withListener listener: MonitorListener) -> PresentableInteractable
}

final class MonitorBuilder: ComponentizedBuilder<MonitorComponent, PresentableInteractable, MonitorDynamicBuildDependency, Void>, MonitorBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MonitorComponent, _ dynamicBuildDependency: MonitorDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MonitorViewController(analyticsManager: component.analyticsManager)
        let interactor = MonitorInteractor(presenter: viewController,
                                           monitorListBuilder: component.monitorListBuilder,
                                           deviceIdentityBuilder: component.deviceIdentityBuilder,
                                           memoryBuilder: component.memoryBuilder,
                                           batteryBuilder: component.batteryBuilder,
                                           diskBuilder: component.diskBuilder,
                                           processorBuilder: component.processorBuilder,
                                           cellularBuilder: component.cellularBuilder)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MonitorBuildable

    func build(withListener listener: MonitorListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
