//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
@testable import StatioMocks

final class DiskViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_diskViewController() {
        let collectionView = DiskListCollectionView()
        let dataSource = DiskListCollectionViewDataSource(collectionView: collectionView)
        let byteFormatter = ByteFormattingMock()
        byteFormatter.formattedBytesForDiskHandler = { _ in "content" }
        let viewController = DiskViewController(analyticsManager: AnalyticsManagingMock(),
                                                diskListCollectionView: collectionView,
                                                diskListDataSource: dataSource,
                                                byteFormatter: byteFormatter)
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.present(snapshot: .init(usage: .init(total: 4, opportunisticAvailable: 1, importantAvailable: 2, available: 3), timestamp: .distantFuture))
        FBSnapshotVerifyViewController(viewController)
    }

}
