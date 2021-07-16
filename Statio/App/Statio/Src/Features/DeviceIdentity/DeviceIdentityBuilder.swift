//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol DeviceIdentityDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
    var deviceModelStream: DeviceModelStreaming { get }
}

class DeviceIdentityComponent: Component<DeviceIdentityDependency> {

    // MARK: - Internal Dependencies

    fileprivate var deviceStaticInfoProvider: DeviceStaticInfoProviding {
        DeviceStaticInfoProvider()
    }

    fileprivate var collectionView: DeviceIdentityCollectionView {
        shared { DeviceIdentityCollectionView() }
    }

    fileprivate var dataSource: DeviceIdentityDataSource {
        shared { DeviceIdentityCollectionViewDataSource(collectionView: collectionView) }
    }

}

/// @mockable
protocol DeviceIdentityInteractable: PresentableInteractable {}

typealias DeviceIdentityDynamicBuildDependency = (
    DeviceIdentityListener
)

/// @mockable
protocol DeviceIdentityBuildable: AnyObject {
    func build(withListener listener: DeviceIdentityListener) -> PresentableInteractable
}

final class DeviceIdentityBuilder: ComponentizedBuilder<DeviceIdentityComponent, PresentableInteractable, DeviceIdentityDynamicBuildDependency, Void>, DeviceIdentityBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: DeviceIdentityComponent, _ dynamicBuildDependency: DeviceIdentityDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = DeviceIdentityViewController(analyticsManager: component.analyticsManager,
                                                          collectionView: component.collectionView,
                                                          dataSource: component.dataSource)
        let interactor = DeviceIdentityInteractor(presenter: viewController,
                                                  deviceStaticInfoProvider: component.deviceStaticInfoProvider,
                                                  deviceModelStream: component.deviceModelStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - DeviceIdentityBuildable

    func build(withListener listener: DeviceIdentityListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
