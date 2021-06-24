//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio

final class RootViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_rootViewController() {
        let viewController = RootViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
