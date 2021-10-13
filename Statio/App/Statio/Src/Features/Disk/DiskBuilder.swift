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

class DiskComponent: Component<DiskDependency> {

    fileprivate var collectionView: DiskListCollectionView {
        shared { DiskListCollectionView() }
    }

    fileprivate var dataSource: DiskListDataSource {
        shared { DiskListCollectionViewDataSource(collectionView: collectionView) }
    }

}

/// @CreateMock
protocol DiskInteractable: PresentableInteractable {}

typealias DiskDynamicBuildDependency = (
    DiskListener
)

/// @CreateMock
protocol DiskBuildable: AnyObject {
    func build(withListener listener: DiskListener) -> PresentableInteractable
}

final class DiskBuilder: ComponentizedBuilder<DiskComponent, PresentableInteractable, DiskDynamicBuildDependency, Void>, DiskBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: DiskComponent, _ dynamicBuildDependency: DiskDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let presenter = DiskViewController(analyticsManager: component.analyticsManager,
                                           diskListCollectionView: component.collectionView,
                                           diskListDataSource: component.dataSource,
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
