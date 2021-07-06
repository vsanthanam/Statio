//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs
import UIKit

protocol MonitorListDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
    var monitorTitleProvider: MonitorTitleProviding { get }
    var monitorIconProvider: MonitorIconProviding { get }
}

class MonitorListComponent: Component<MonitorListDependency> {

    // MARK: - Internal Dependencies

    fileprivate var collectionView: MonitorListCollectionView {
        shared {
            MonitorListCollectionView()
        }
    }

    fileprivate var dataSource: MonitorListDataSource {
        shared {
            MonitorListCollectionViewDataSource(collectionView: collectionView)
        }
    }

}

/// @mockable
protocol MonitorListInteractable: PresentableInteractable {
    var viewController: MonitorListViewControllable { get }
}

typealias MonitorListDynamicBuildDependency = (
    MonitorListListener
)

/// @mockable
protocol MonitorListBuildable: AnyObject {
    func build(withListener listener: MonitorListListener) -> MonitorListInteractable
}

final class MonitorListBuilder: ComponentizedBuilder<MonitorListComponent, MonitorListInteractable, MonitorListDynamicBuildDependency, Void>, MonitorListBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: MonitorListComponent, _ dynamicBuildDependency: MonitorListDynamicBuildDependency) -> MonitorListInteractable {
        let listener = dynamicBuildDependency
        let viewController = MonitorListViewController(analyticsManager: component.analyticsManager,
                                                       collectionView: component.collectionView,
                                                       dataSource: component.dataSource,
                                                       monitorTitleProvider: component.monitorTitleProvider,
                                                       monitorIconProvider: component.monitorIconProvider)
        let interactor = MonitorListInteractor(presenter: viewController)
        viewController.listener = interactor
        interactor.listener = listener
        return interactor
    }

    // MARK: - MonitorListBuildable

    func build(withListener listener: MonitorListListener) -> MonitorListInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
