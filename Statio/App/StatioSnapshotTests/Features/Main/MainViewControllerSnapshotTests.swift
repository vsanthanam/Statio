//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
final class MainViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_mainViewController() {
        let viewController = MainViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.showTabs(AppState.allCases.map(\.viewModel))
        FBSnapshotVerifyViewController(viewController)
    }

}
