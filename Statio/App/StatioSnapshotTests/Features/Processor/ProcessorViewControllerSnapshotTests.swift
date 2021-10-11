//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
@testable import StatioMocks

final class ProcessorControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_processorViewController() {
        let viewController = ProcessorViewController(analyticsManager: AnalyticsManagingMock())
        viewController.loadView()
        viewController.viewDidLoad()
        FBSnapshotVerifyViewController(viewController)
    }

}
