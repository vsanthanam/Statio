//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol MonitorDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class MonitorComponent: Component<MonitorDependency> {}

/// @mockable
protocol MonitorInteractable: PresentableInteractable {}

typealias MonitorDynamicBuildDependency = (
    MonitorListener
)

/// @mockable
protocol MonitorBuildable: AnyObject {
    func build(withListener listener: MonitorListener) -> PresentableInteractable
}

final class MonitorBuilder: ComponentizedBuilder<MonitorComponent, PresentableInteractable, MonitorDynamicBuildDependency, Void>, MonitorBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MonitorComponent, _ dynamicBuildDependency: MonitorDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MonitorViewController(analyticsManager: component.analyticsManager)
        let interactor = MonitorInteractor(presenter: viewController)
        viewController.listener = interactor
        interactor.listener = listener
        return interactor
    }

    // MARK: - MonitorBuildable

    func build(withListener listener: MonitorListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
