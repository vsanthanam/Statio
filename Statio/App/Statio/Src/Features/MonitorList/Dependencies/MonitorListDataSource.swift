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

extension UICollectionViewDiffableDataSource: MonitorListDataSource where SectionIdentifierType == MonitorCategoryIdentifier, ItemIdentifierType == MonitorIdentifier {
    func apply(_ snapshot: NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorIdentifier>) {
        apply(snapshot, animatingDifferences: true)
    }
}
