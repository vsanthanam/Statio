//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio

final class MonitorViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_mainViewController() {
        let viewController = MonitorViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
