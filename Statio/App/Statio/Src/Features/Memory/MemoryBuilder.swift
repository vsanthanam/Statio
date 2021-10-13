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
    var byteFormatter: ByteFormatting { get }
    var memorySnapshotStream: MemorySnapshotStreaming { get }
}

class MemoryComponent: Component<MemoryDependency> {

    fileprivate var collectionView: MemoryListCollectionView {
        shared { MemoryListCollectionView() }
    }

    fileprivate var dataSource: MemoryListDataSource {
        shared { MemoryListCollectionViewDataSource(collectionView: collectionView) }
    }

}

/// @CreateMock
protocol MemoryInteractable: PresentableInteractable {}

typealias MemoryDynamicBuildDependency = (
    MemoryListener
)

/// @CreateMock
protocol MemoryBuildable: AnyObject {
    func build(withListener listener: MemoryListener) -> PresentableInteractable
}

final class MemoryBuilder: ComponentizedBuilder<MemoryComponent, PresentableInteractable, MemoryDynamicBuildDependency, Void>, MemoryBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MemoryComponent, _ dynamicBuildDependency: MemoryDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MemoryViewController(analyticsManager: component.analyticsManager,
                                                  memoryListCollectionView: component.collectionView,
                                                  memoryListDataSource: component.dataSource,
                                                  byteFormatter: component.byteFormatter)
        let interactor = MemoryInteractor(presenter: viewController,
                                          memorySnapshotStream: component.memorySnapshotStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MemoryBuildable

    func build(withListener listener: MemoryListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
