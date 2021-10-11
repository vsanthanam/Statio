//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
@testable import StatioMocks

final class MonitorViewControllerSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_monitorViewController() {
        let viewController = MonitorViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
