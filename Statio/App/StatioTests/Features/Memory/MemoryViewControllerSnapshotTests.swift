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

    func test_deviceIdentityViewController() {
        let viewController = MemoryViewController(analyticsManager: AnalyticsManagingMock())
        FBSnapshotVerifyViewController(viewController)
    }

}
