//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol AccelerometerDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class AccelerometerComponent: Component<AccelerometerDependency> {}

/// @CreateMock
protocol AccelerometerInteractable: PresentableInteractable {}

typealias AccelerometerDynamicBuildDependency = (
    AccelerometerListener
)

/// @CreateMock
protocol AccelerometerBuildable: AnyObject {
    func build(withListener listener: AccelerometerListener) -> PresentableInteractable
}

final class AccelerometerBuilder: ComponentizedBuilder<AccelerometerComponent, PresentableInteractable, AccelerometerDynamicBuildDependency, Void>, AccelerometerBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: AccelerometerComponent, _ dynamicBuildDependency: AccelerometerDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = AccelerometerViewController(analyticsManager: component.analyticsManager)
        let interactor = AccelerometerInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - AccelerometerBuildable

    func build(withListener listener: AccelerometerListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
