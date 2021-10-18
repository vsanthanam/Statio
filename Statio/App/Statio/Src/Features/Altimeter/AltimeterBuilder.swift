//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol AltimeterDependency: Dependency {}

class AltimeterComponent: Component<AltimeterDependency> {}

/// @CreateMock
protocol AltimeterInteractable: PresentableInteractable {}

typealias AltimeterDynamicBuildDependency = (
    AltimeterListener
)

/// @CreateMock
protocol AltimeterBuildable: AnyObject {
    func build(withListener listener: AltimeterListener) -> PresentableInteractable
}

final class AltimeterBuilder: ComponentizedBuilder<AltimeterComponent, PresentableInteractable, AltimeterDynamicBuildDependency, Void>, AltimeterBuildable {

    // MARK: = ComponentizedBuilder

    override func build(with component: AltimeterComponent, _ dynamicBuildDependency: AltimeterDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = AltimeterViewController()
        let interactor = AltimeterInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - AltimeterBuildable

    func build(withListener listener: AltimeterListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
