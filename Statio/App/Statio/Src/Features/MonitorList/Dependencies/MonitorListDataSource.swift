//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

/// @mockable
protocol MonitorListDataSource: AnyObject {
    func itemIdentifier(for indexPath: IndexPath) -> MonitorListRow?
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorListRow>)
}

typealias MonitorListCollectionViewDataSource = UICollectionViewDiffableDataSource<MonitorCategoryIdentifier, MonitorListRow>

extension UICollectionViewDiffableDataSource: MonitorListDataSource where SectionIdentifierType == MonitorCategoryIdentifier, ItemIdentifierType == MonitorListRow {

    // MARK: - Initializers

    convenience init(collectionView: MonitorListCollectionView) {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, MonitorListRow> { cell, _, row in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = row.name
            configuration.image = row.icon
            cell.contentConfiguration = configuration
        }
        self.init(collectionView: collectionView,
                  cellProvider: { view, indexPath, model in
                      view.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: model)
                  })
    }

    // MARK: - MonitorListDataSource

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorListRow>) {
        apply(snapshot, animatingDifferences: true)
    }

}
