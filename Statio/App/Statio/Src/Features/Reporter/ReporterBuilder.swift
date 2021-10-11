//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol ReporterDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class ReporterComponent: Component<ReporterDependency> {}

/// @mockable
protocol ReporterInteractable: PresentableInteractable {}

typealias ReporterDynamicBuildDependency = (
    ReporterListener
)

/// @mockable
protocol ReporterBuildable: AnyObject {
    func build(withListener listener: ReporterListener) -> PresentableInteractable
}

final class ReporterBuilder: ComponentizedBuilder<ReporterComponent, PresentableInteractable, ReporterDynamicBuildDependency, Void>, ReporterBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: ReporterComponent, _ dynamicBuildDependency: ReporterDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = ReporterViewController(analyticsManager: component.analyticsManager)
        let interactor = ReporterInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - ReporterBuildable

    func build(withListener listener: ReporterListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
