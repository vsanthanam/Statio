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
        let collectionView = MonitorListCollectionView()
        let monitorTitleProvider = MonitorTitleProvidingMock()
        monitorTitleProvider.titleHandler = { _ in
            "Title"
        }
        let monitorIconProvider = MonitorIconProvidingMock()
        monitorIconProvider.imageHandler = { _, size, color in
            MonitorIconProvider().image(forIdentifier: .disk, size: size, color: color)
        }
        let dataSource = MonitorListCollectionViewDataSource(collectionView: collectionView,
                                                             monitorTitleProvider: monitorTitleProvider,
                                                             monitorIconProvider: monitorIconProvider)

        let viewController = MonitorListViewController(analyticsManager: AnalyticsManagingMock(), collectionView: collectionView, dataSource: dataSource)
        viewController.viewDidLoad()
        viewController.viewDidAppear(true)
        viewController.applyIdentifiers(MonitorIdentifier.allCases, categories: MonitorCategoryIdentifier.allCases)
        FBSnapshotVerifyViewController(viewController)
    }

}
