//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio

final class DeviceIdentityViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_mainViewController() {
        let viewController = DeviceIdentityViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
