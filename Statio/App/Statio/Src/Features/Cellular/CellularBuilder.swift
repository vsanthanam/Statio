//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol CellularDependency: Dependency {}

class CellularComponent: Component<CellularDependency> {}

/// @mockable
protocol CellularInteractable: PresentableInteractable {}

typealias CellularDynamicBuildDependency = (
    CellularListener
)

/// @mockable
protocol CellularBuildable: AnyObject {
    func build(withListener listener: CellularListener) -> PresentableInteractable
}

final class CellularBuilder: ComponentizedBuilder<CellularComponent, PresentableInteractable, CellularDynamicBuildDependency, Void>, CellularBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: CellularComponent, _ dynamicBuildDependency: CellularDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = CellularViewControler()
        let interactor = CellularInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - CellularBuildable

    func build(withListener listener: CellularListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
