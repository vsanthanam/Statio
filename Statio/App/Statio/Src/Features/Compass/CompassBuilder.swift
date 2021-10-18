//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol CompassDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class CompassComponent: Component<CompassDependency> {}

/// @CreateMock
protocol CompassInteractable: PresentableInteractable {}

typealias CompassDynamicBuildDependency = (
    CompassListener
)

/// @CreateMock
protocol CompassBuildable: AnyObject {
    func build(withListener listener: CompassListener) -> PresentableInteractable
}

final class CompassBuilder: ComponentizedBuilder<CompassComponent, PresentableInteractable, CompassDynamicBuildDependency, Void>, CompassBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: CompassComponent, _ dynamicBuildDependency: CompassDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = CompassViewController(analyticsManager: component.analyticsManager)
        let interactor = CompassInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - CompassBuildable

    func build(withListener listener: CompassListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
