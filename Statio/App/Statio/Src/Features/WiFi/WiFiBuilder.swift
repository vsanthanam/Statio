//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol WiFiDependency: Dependency {}

class WiFiComponent: Component<WiFiDependency> {}

/// @mockable
protocol WiFiInteractable: PresentableInteractable {}

typealias WiFiDynamicBuildDependency = (
    WiFiListener
)

/// @mockable
protocol WiFiBuildable: AnyObject {
    func build(withListener listener: WiFiListener) -> PresentableInteractable
}

final class WiFiBuilder: ComponentizedBuilder<WiFiComponent, PresentableInteractable, WiFiDynamicBuildDependency, Void>, WiFiBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: WiFiComponent, _ dynamicBuildDependency: WiFiDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = WiFiViewController()
        let interactor = WiFiInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - WiFiBuildable

    func build(withListener listener: WiFiListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
