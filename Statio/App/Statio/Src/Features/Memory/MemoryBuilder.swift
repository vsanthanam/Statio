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

class MemoryComponent: Component<MemoryDependency> {

    // MARK: - Published Dependencies

    var memorySnapshotStream: MemorySnapshotStreaming {
        mutableMemorySnapshotStream
    }

    // MARK: - Internal Dependencies

    fileprivate var memoryMonitor: MemoryMonitoring {
        MemoryMonitor(mutableMemorySnapshotStream: mutableMemorySnapshotStream)
    }

    fileprivate var collectionView: MemoryListCollectionView {
        shared { MemoryListCollectionView() }
    }

    fileprivate var dataSource: MemoryListDataSource {
        shared { MemoryListCollectionViewDataSource(collectionView: collectionView) }
    }

    // MARK: - Private Dependencies

    private var mutableMemorySnapshotStream: MutableMemorySnapshotStreaming {
        shared { MemorySnapshotStream() }
    }

}

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
        let viewController = MemoryViewController(analyticsManager: component.analyticsManager,
                                                  memoryListCollectionView: component.collectionView,
                                                  memoryListDataSource: component.dataSource)
        let interactor = MemoryInteractor(presenter: viewController,
                                          memoryMonitor: component.memoryMonitor,
                                          memorySnapshotStream: component.memorySnapshotStream)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MemoryBuildable

    func build(withListener listener: MemoryListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
