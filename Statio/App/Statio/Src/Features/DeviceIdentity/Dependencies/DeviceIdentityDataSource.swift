//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

/// @mockable
protocol DeviceIdentityDataSource: AnyObject {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<DeviceIdentityCategory, DeviceIdentityRow>)
}

typealias DeviceIdentityCollectionViewDataSource = UICollectionViewDiffableDataSource<DeviceIdentityCategory, DeviceIdentityRow>

extension UICollectionViewDiffableDataSource: DeviceIdentityDataSource where SectionIdentifierType == DeviceIdentityCategory, ItemIdentifierType == DeviceIdentityRow {

    convenience init(collectionView: UICollectionView) {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, DeviceIdentityRow> { cell, _, row in
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

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<DeviceIdentityCategory, DeviceIdentityRow>) {
        apply(snapshot, animatingDifferences: true)
    }
}
