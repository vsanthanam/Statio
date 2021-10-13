//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @CreateMock
protocol MonitorListViewControllable: ViewControllable {}

/// @CreateMock
protocol MonitorListPresentableListener: AnyObject {
    func didSelectMonitor(withIdentifier identifier: MonitorIdentifier)
}

final class MonitorListViewController: ScopeViewController, MonitorListPresentable, MonitorListViewControllable, UICollectionViewDelegate {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging,
         collectionView: MonitorListCollectionViewable,
         dataSource: MonitorListDataSource,
         monitorTitleProvider: MonitorTitleProviding,
         monitorIconProvider: MonitorIconProviding) {
        self.analyticsManager = analyticsManager
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.monitorTitleProvider = monitorTitleProvider
        self.monitorIconProvider = monitorIconProvider
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statio"
        collectionView.delegate = self
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
        var snapshot = NSDiffableDataSourceSnapshot<MonitorCategoryIdentifier, MonitorListRow>()
        snapshot.appendSections(categories)
        for category in MonitorCategoryIdentifier.allCases {
            let items = identifiers
                .filter { $0.category == category }
                .map { [monitorTitleProvider, monitorIconProvider] identifier in
                    MonitorListRow(identifier: identifier,
                                   name: monitorTitleProvider.title(for: identifier),
                                   icon: monitorIconProvider.image(forIdentifier: identifier,
                                                                   size: .init(width: 24,
                                                                               height: 24),
                                                                   color: .label))
                }
            snapshot.appendItems(items, toSection: category)
        }
        dataSource.apply(snapshot)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let row = dataSource.itemIdentifier(for: indexPath) {
            listener?.didSelectMonitor(withIdentifier: row.identifier)
        }
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    private let collectionView: MonitorListCollectionViewable
    private let dataSource: MonitorListDataSource
    private let monitorTitleProvider: MonitorTitleProviding
    private let monitorIconProvider: MonitorIconProviding
}
