//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

/// @mockable
protocol MonitorListDataSource: AnyObject {
    func itemIdentifier(for indexPath: IndexPath) -> MonitorIdentifier?
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorIdentifier>)
}

typealias MonitorListCollectionViewDataSource = UICollectionViewDiffableDataSource<MonitorCategoryIdentifier, MonitorIdentifier>

extension UICollectionViewDiffableDataSource: MonitorListDataSource where SectionIdentifierType == MonitorCategoryIdentifier, ItemIdentifierType == MonitorIdentifier {

    convenience init(collectionView: UICollectionView,
                     monitorTitleProvider: MonitorTitleProviding,
                     monitorIconProvider: MonitorIconProviding) {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, MonitorIdentifier> { cell, _, identifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = monitorTitleProvider.title(for: identifier)
            configuration.image = monitorIconProvider.image(forIdentifier: identifier,
                                                            size: .init(width: 24, height: 24))
            cell.contentConfiguration = configuration
        }
        self.init(collectionView: collectionView,
                  cellProvider: { view, indexPath, model in
                      view.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: model)
                  })
    }

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorIdentifier>) {
        apply(snapshot, animatingDifferences: true)
    }

}
