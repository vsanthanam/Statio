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
    var batteryLevelStream: BatteryLevelStreaming { get }
    var batteryStateStream: BatteryStateStreaming { get }
}

class BatteryComponent: Component<BatteryDependency> {

    // MARK: - Internal Dependencies

    fileprivate var colllectionView: BatteryCollectionView {
        shared { BatteryCollectionView() }
    }

    fileprivate var dataSource: BatteryDataSource {
        shared { BatteryCollectionViewDataSource(collectionView: colllectionView) }
    }

}

/// @CreateMock
protocol BatteryInteractable: PresentableInteractable {}

typealias BatteryDynamicBuildDependency = (
    BatteryListener
)

/// @CreateMock
protocol BatteryBuildable: AnyObject {
    func build(withListener listener: BatteryListener) -> PresentableInteractable
}

final class BatteryBuilder: ComponentizedBuilder<BatteryComponent, PresentableInteractable, BatteryDynamicBuildDependency, Void>, BatteryBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: BatteryComponent, _ dynamicBuildDependency: BatteryDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = BatteryViewController(analyticsManager: component.analyticsManager,
                                                   collectionView: component.colllectionView,
                                                   dataSource: component.dataSource)
        let interactor = BatteryInteractor(presenter: viewController,
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
