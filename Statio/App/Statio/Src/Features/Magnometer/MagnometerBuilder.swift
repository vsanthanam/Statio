//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol MagnometerDependency: Dependency {}

class MagnometerComponent: Component<MagnometerDependency> {}

protocol MagnometerInteractable: PresentableInteractable {}

typealias MagnometerDynamicBuildDependency = (
    MagnometerListener
)

/// @CreateMock
protocol MagnometerBuildable: AnyObject {
    func build(withListener listener: MagnometerListener) -> PresentableInteractable
}

final class MagnometerBuilder: ComponentizedBuilder<MagnometerComponent, PresentableInteractable, MagnometerDynamicBuildDependency, Void>, MagnometerBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: MagnometerComponent, _ dynamicBuildDependency: MagnometerDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MagnometerViewController()
        let interactor = MagnometerInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MagnometerBuildable

    func build(withListener listener: MagnometerListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
