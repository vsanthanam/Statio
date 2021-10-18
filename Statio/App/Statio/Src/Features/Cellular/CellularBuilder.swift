//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol CellularDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class CellularComponent: Component<CellularDependency> {}

/// @CreateMock
protocol CellularInteractable: PresentableInteractable {}

typealias CellularDynamicBuildDependency = (
    CellularListener
)

/// @CreateMock
protocol CellularBuildable: AnyObject {
    func build(withListener listener: CellularListener) -> PresentableInteractable
}

final class CellularBuilder: ComponentizedBuilder<CellularComponent, PresentableInteractable, CellularDynamicBuildDependency, Void>, CellularBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: CellularComponent, _ dynamicBuildDependency: CellularDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = CellularViewController(analyticsManager: component.analyticsManager)
        let interactor = CellularInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - CellularBuildable

    func build(withListener listener: CellularListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
