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

/// @CreateMock
protocol ReporterInteractable: PresentableInteractable {}

/// @CreateMock
protocol ReporterBuildable: AnyObject {
    func build() -> PresentableInteractable
}

final class ReporterBuilder: SimpleComponentizedBuilder<ReporterComponent, PresentableInteractable>, ReporterBuildable {

    // MARK: - SimpleComponentizedBuilder

    override func build(with component: ReporterComponent) -> PresentableInteractable {
        let viewController = ReporterViewController(analyticsManager: component.analyticsManager)
        let interactor = ReporterInteractor(presenter: viewController)
        return interactor
    }

}
