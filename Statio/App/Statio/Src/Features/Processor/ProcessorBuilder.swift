//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol ProcessorDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
    var processorSnapshotStream: ProcessorSnapshotStreaming { get }
}

class ProcessorComponent: Component<ProcessorDependency> {}

typealias ProcessorDynamicBuildDependency = (
    ProcessorListener
)

/// @CreateMock
protocol ProcessorInteractable: PresentableInteractable {}

/// @CreateMock
protocol ProcessorBuildable: AnyObject {
    func build(withListener listener: ProcessorListener) -> PresentableInteractable
}

final class ProcessorBuilder: ComponentizedBuilder<ProcessorComponent, PresentableInteractable, ProcessorDynamicBuildDependency, Void>, ProcessorBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: ProcessorComponent, _ dynamicBuildDependency: ProcessorDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = ProcessorViewController(analyticsManager: component.analyticsManager)
        let interactor = ProcessorInteractor(presenter: viewController,
                                             processorSnapshotStream: component.processorSnapshotStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - ProcessorBuildable

    func build(withListener listener: ProcessorListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }
}
