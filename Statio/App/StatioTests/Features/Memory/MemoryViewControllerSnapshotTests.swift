//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio

final class MemoryViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_memoryViewController() {
        let collectionView = MemoryListCollectionView()
        let dataSource = MemoryListCollectionViewDataSource(collectionView: collectionView)
        let viewController = MemoryViewController(analyticsManager: AnalyticsManagingMock(),
                                                  memoryListCollectionView: collectionView,
                                                  memoryListDataSource: dataSource,
                                                  byteFormatter: ByteFormatter())
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.present(snapshot: .init(usage: .init(physical: 500,
                                                            free: 100,
                                                            active: 100,
                                                            inactive: 100,
                                                            wired: 100,
                                                            pageIns: 100,
                                                            pageOuts: 100),
                                               timestamp: .distantPast))
        FBSnapshotVerifyViewController(viewController)
    }

}
