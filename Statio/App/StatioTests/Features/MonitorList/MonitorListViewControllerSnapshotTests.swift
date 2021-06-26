//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio

final class MonitorListViewControllerSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_monitorListViewController() {
        let collectionView: UICollectionView = {
            var config = UICollectionLayoutListConfiguration(appearance: .grouped)
            config.showsSeparators = true
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            return collectionView
        }()

        let dataSource: MonitorListDataSource = {
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
        }()

        let viewController = MonitorListViewController(analyticsManager: AnalyticsManagingMock(), collectionView: collectionView, dataSource: dataSource)
        viewController.viewDidLoad()
        viewController.viewDidAppear(true)
        viewController.applyIdentifiers(MonitorIdentifier.allCases, categories: MonitorCategoryIdentifier.allCases)
        FBSnapshotVerifyViewController(viewController)
    }

}
