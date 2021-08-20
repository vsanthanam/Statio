//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

/// @mockable
protocol BatteryDataSource: AnyObject {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<Int, BatteryRow>)
}

typealias BatteryCollectionViewDataSource = UICollectionViewDiffableDataSource<Int, BatteryRow>

extension UICollectionViewDiffableDataSource: BatteryDataSource where SectionIdentifierType == Int, ItemIdentifierType == BatteryRow {

    convenience init(collectionView: UICollectionView) {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, BatteryRow> { cell, _, row in
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = row.title
            configuration.secondaryText = row.value
            cell.contentConfiguration = configuration
        }
        self.init(collectionView: collectionView,
                  cellProvider: { view, indexPath, model in
                      view.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: model)
                  })
    }

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<Int, BatteryRow>) {
        apply(snapshot, animatingDifferences: true)
    }
}
