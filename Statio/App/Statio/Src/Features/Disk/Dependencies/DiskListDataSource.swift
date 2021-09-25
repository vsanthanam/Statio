//
// Statio
// Varun Santhanam
//

import Analytics
import Charts
import Foundation
import UIKit

/// @mockable
protocol DiskListDataSource: AnyObject {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<DiskListSection, DiskListRow>)
}

typealias DiskListCollectionViewDataSource = UICollectionViewDiffableDataSource<DiskListSection, DiskListRow>

extension UICollectionViewDiffableDataSource: DiskListDataSource where SectionIdentifierType == DiskListSection, ItemIdentifierType == DiskListRow {

    convenience init(collectionView: UICollectionView) {
        let legendRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DiskListRow> { cell, _, row in
            guard case let .legendEntry(name, value) = row else {
                loggedFatalError("Invalid Cell", key: "disk_list_collection_view_data_source")
            }
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = name
            configuration.secondaryText = value
            cell.contentConfiguration = configuration
        }
        self.init(collectionView: collectionView,
                  cellProvider: { view, indexPath, model in
                      switch model {
                      case .legendEntry:
                          return view.dequeueConfiguredReusableCell(using: legendRegistration,
                                                                    for: indexPath,
                                                                    item: model)
                      case .gaugeData:
                          fatalError()
                      }
                  })
    }

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<DiskListSection, DiskListRow>) {
        apply(snapshot, animatingDifferences: false)
    }
}
