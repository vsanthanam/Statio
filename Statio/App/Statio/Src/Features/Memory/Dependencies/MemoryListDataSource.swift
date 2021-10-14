//
// Statio
// Varun Santhanam
//

import Analytics
import Charts
import Foundation
import UIKit

/// @CreateMock
protocol MemoryListDataSource: AnyObject {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MemoryListSection, MemoryListRow>)
}

typealias MemoryListCollectionViewDataSource = UICollectionViewDiffableDataSource<MemoryListSection, MemoryListRow>

extension UICollectionViewDiffableDataSource: MemoryListDataSource where SectionIdentifierType == MemoryListSection, ItemIdentifierType == MemoryListRow {

    convenience init(collectionView: UICollectionView) {
        let legendRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MemoryListRow> { cell, _, row in
            guard case let .legendEntry(name, value) = row else {
                loggedFatalError("Invalid Cell", key: "memory_list_collection_view_data_source")
            }
            var configuration = UIListContentConfiguration.valueCell()
            configuration.text = name
            configuration.secondaryText = value
            cell.contentConfiguration = configuration
        }
        let chartRegistration = UICollectionView.CellRegistration<MemoryPressureChartListCell, MemoryListRow> { cell, _, row in
            guard case let .chartData(data) = row else {
                loggedFatalError("Invalid Cell", key: "memory_list_collection_view_data_source")
            }
            cell.apply(data)
        }
        self.init(collectionView: collectionView) { view, indexPath, model in
            switch model {
            case .legendEntry:
                return view.dequeueConfiguredReusableCell(using: legendRegistration, for: indexPath, item: model)
            case .chartData:
                return view.dequeueConfiguredReusableCell(using: chartRegistration, for: indexPath, item: model)
            }
        }
    }

    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MemoryListSection, MemoryListRow>) {
        apply(snapshot, animatingDifferences: false)
    }
}
