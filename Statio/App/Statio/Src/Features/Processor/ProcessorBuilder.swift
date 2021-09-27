//
// Statio
// Varun Santhanam
//

import Foundation
import NeedleFoundation
import ShortRibs

protocol ProcessorDependency: Dependency {}

class ProcessorComponent: Component<ProcessorDependency> {}

typealias ProcessorDynamicBuildDependency = (
    ProcessorListener
)

/// @mockable
protocol ProcessorInteractable: PresentableInteractable {}

/// @mockable
protocol ProcessorBuildable: AnyObject {
    func build(withListener listener: ProcessorListener) -> PresentableInteractable
}

final class ProcessorBuilder: ComponentizedBuilder<ProcessorComponent, PresentableInteractable, ProcessorDynamicBuildDependency, Void>, ProcessorBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: ProcessorComponent, _ dynamicBuildDependency: ProcessorDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = ProcessorViewController()
        let interactor = ProcessorInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - ProcessorBuildable

    func build(withListener listener: ProcessorListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
