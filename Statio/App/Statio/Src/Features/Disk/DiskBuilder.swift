//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol DiskDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
    var diskSnapshotStream: DiskSnapshotStreaming { get }
    var byteFormatter: ByteFormatting { get }
}

class DiskComponent: Component<DiskDependency> {}

/// @mockable
protocol DiskInteractable: PresentableInteractable {}

typealias DiskDynamicBuildDependency = (
    DiskListener
)

/// @mockable
protocol DiskBuildable: AnyObject {
    func build(withListener listener: DiskListener) -> PresentableInteractable
}

final class DiskBuilder: ComponentizedBuilder<DiskComponent, PresentableInteractable, DiskDynamicBuildDependency, Void>, DiskBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: DiskComponent, _ dynamicBuildDependency: DiskDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let presenter = DiskViewController(analyticsManager: component.analyticsManager,
                                           byteFormatter: component.byteFormatter)
        let interactor = DiskInteractor(presenter: presenter,
                                        diskSnapshotStream: component.diskSnapshotStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - DiskBuildable

    func build(withListener listener: DiskListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
