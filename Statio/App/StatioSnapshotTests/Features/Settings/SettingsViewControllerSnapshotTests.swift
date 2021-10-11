//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
@testable import StatioMocks

final class SettingsViewControllerSnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_settingsViewController() {
        let viewController = SettingsViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
