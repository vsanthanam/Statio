//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @mockable
protocol MonitorListViewControllable: ViewControllable {}

/// @mockable
protocol MonitorListPresentableListener: AnyObject {
    func didSelectMonitor(withIdentifier identifier: MonitorIdentifier)
}

final class MonitorListViewController: ScopeViewController, MonitorListPresentable, MonitorListViewControllable, UICollectionViewDelegate {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging,
         collectionView: MonitorListCollectionView,
         dataSource: MonitorListDataSource) {
        self.analyticsManager = analyticsManager
        self.collectionView = collectionView
        self.dataSource = dataSource
        super.init(ScopeView.init)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statio"
        specializedView.addSubview(collectionView.uiview)
        collectionView.uiview.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.monitor_list_vc_impression)
    }

    // MARK: - MonitorListPresentable

    weak var listener: MonitorListPresentableListener?

    func applyIdentifiers(_ identifiers: [MonitorIdentifier], categories: [MonitorCategoryIdentifier]) {
        var snapshot = NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorIdentifier>()
        snapshot.appendSections(categories)
        for category in MonitorCategoryIdentifier.allCases {
            let items = identifiers.filter { $0.category == category }
            snapshot.appendItems(items, toSection: category)
        }
        dataSource.apply(snapshot)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let item = dataSource.itemIdentifier(for: indexPath) {
            listener?.didSelectMonitor(withIdentifier: item)
        }
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    private let collectionView: MonitorListCollectionView
    private let dataSource: MonitorListDataSource
}

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

/// @mockable
protocol MonitorListCollectionView: Any {
    var uiview: UIView { get }
    var delegate: UICollectionViewDelegate? { get set }
}

extension UICollectionView: MonitorListCollectionView {
    var uiview: UIView { self }
}
