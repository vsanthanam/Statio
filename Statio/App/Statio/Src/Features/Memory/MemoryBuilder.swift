//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol MemoryDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class MemoryComponent: Component<MemoryDependency> {}

/// @mockable
protocol MemoryInteractable: PresentableInteractable {}

typealias MemoryDynamicBuildDependency = (
    MemoryListener
)

/// @mockable
protocol MemoryBuildable: AnyObject {
    func build(withListener listener: MemoryListener) -> PresentableInteractable
}

final class MemoryBuilder: ComponentizedBuilder<MemoryComponent, PresentableInteractable, MemoryDynamicBuildDependency, Void>, MemoryBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MemoryComponent, _ dynamicBuildDependency: MemoryDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MemoryViewController(analyticsManager: component.analyticsManager)
        let interactor = MemoryInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MemoryBuildable

    func build(withListener listener: MemoryListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
