//
// Aro
// Varun Santhanam
//

@testable import Statio
import FBSnapshotTestCase

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
