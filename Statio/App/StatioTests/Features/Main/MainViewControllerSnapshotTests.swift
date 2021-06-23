//
// Aro
// Varun Santhanam
//

@testable import Statio
import FBSnapshotTestCase

final class MainViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_mainViewController() {
        let viewController = MainViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
