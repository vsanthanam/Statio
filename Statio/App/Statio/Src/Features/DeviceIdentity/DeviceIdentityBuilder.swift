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
}

class DeviceIdentityComponent: Component<DeviceIdentityDependency> {

    // MARK: - Internal Dependencies

    fileprivate var deviceNameProvider: DeviceNameProviding {
        DeviceNameProvider()
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
        let viewController = DeviceIdentityViewController(analyticsManager: component.analyticsManager)
        let interactor = DeviceIdentityInteractor(presenter: viewController, deviceNameProvider: component.deviceNameProvider)
        viewController.listener = interactor
        interactor.listener = listener
        return interactor
    }

    // MARK: - DeviceIdentityBuildable

    func build(withListener listener: DeviceIdentityListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
