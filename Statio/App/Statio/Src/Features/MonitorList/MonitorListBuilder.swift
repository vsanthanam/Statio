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
}

class MonitorListComponent: Component<MonitorListDependency> {

    fileprivate var collectionView: UICollectionView {
        shared {
            var config = UICollectionLayoutListConfiguration(appearance: .grouped)
            config.showsSeparators = true
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            return collectionView
        }
    }

    fileprivate var dataSource: MonitorListDataSource {
        shared {
            let registration = UICollectionView.CellRegistration<UICollectionViewListCell, MonitorIdentifier> { cell, _, model in
                var configuration = cell.defaultContentConfiguration()
                configuration.text = model.rawValue.capitalized
                cell.contentConfiguration = configuration
            }
            let dataSource = UICollectionViewDiffableDataSource<MonitorCategoryIdentifier, MonitorIdentifier>(collectionView: collectionView,
                                                                                                              cellProvider: { view, indexPath, model in
                                                                                                                  view.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: model)
                                                                                                              })
            return dataSource
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
                                                       dataSource: component.dataSource)
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
