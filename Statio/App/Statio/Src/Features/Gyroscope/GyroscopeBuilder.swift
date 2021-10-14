//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol GyroscopeDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class GyroscopeComponent: Component<GyroscopeDependency> {}

protocol GyroscopeInteractable: PresentableInteractable {}

typealias GyroscopeDynamicBuildDependency = (
    GyroscopeListener
)

/// @CreateMock
protocol GyroscopeBuildable: AnyObject {
    func build(withListener listener: GyroscopeListener) -> PresentableInteractable
}

final class GyroscopeBuilder: ComponentizedBuilder<GyroscopeComponent, PresentableInteractable, GyroscopeDynamicBuildDependency, Void>, GyroscopeBuildable {

    // MARK: - ComponentizedBuider

    override func build(with component: GyroscopeComponent, _ dynamicBuildDependency: GyroscopeDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = GyroscopeViewController(analyticsManager: component.analyticsManager)
        let interactor = GyroscopeInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - GyroscopeBuildable

    func build(withListener listener: GyroscopeListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
