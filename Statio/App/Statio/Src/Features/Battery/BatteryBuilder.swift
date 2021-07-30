//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol BatteryDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class BatteryComponent: Component<BatteryDependency> {

    var batteryLevelStream: BatteryLevelStreaming {
        mutableBatteryLevelStream
    }

    var batteryStateStream: BatteryStateStreaming {
        mutableBatteryStateStream
    }

    fileprivate var batteryMonitor: BatteryMonitoring {
        BatteryMonitor(mutableBatteryLevelStream: mutableBatteryLevelStream,
                       mutableBatteryStateStream: mutableBatteryStateStream)
    }

    private var mutableBatteryLevelStream: MutableBatteryLevelStreaming {
        shared { BatteryLevelStream() }
    }

    private var mutableBatteryStateStream: MutableBatteryStateStreaming {
        shared { BatteryStateStream() }
    }

}

/// @mockable
protocol BatteryInteractable: PresentableInteractable {}

typealias BatteryDynamicBuildDependency = (
    BatteryListener
)

/// @mockable
protocol BatteryBuildable: AnyObject {
    func build(withListener listener: BatteryListener) -> PresentableInteractable
}

final class BatteryBuilder: ComponentizedBuilder<BatteryComponent, PresentableInteractable, BatteryDynamicBuildDependency, Void>, BatteryBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: BatteryComponent, _ dynamicBuildDependency: BatteryDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = BatteryViewController(analyticsManager: component.analyticsManager)
        let interactor = BatteryInteractor(presenter: viewController,
                                           batteryMonitor: component.batteryMonitor,
                                           batteryLevelStream: component.batteryLevelStream,
                                           batteryStateStream: component.batteryStateStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - BatteryBuildable

    func build(withListener listener: BatteryListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}