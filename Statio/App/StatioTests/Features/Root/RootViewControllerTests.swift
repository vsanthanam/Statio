//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class RootViewControllerTests: TestCase {

    let listener = RootPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()

    var viewController: RootViewController!

    override func setUp() {
        viewController = .init(analyticsManager: analyticsManager)
        viewController.listener = listener
    }

    func test_viewDidAppear_completesTrace() {
        XCTAssertEqual(analyticsManager.stopCallCount, 0)

        analyticsManager.stopHandler = { trace, segmentation in
            XCTAssertNil(segmentation)
            guard let trace = trace as? AnalyticsTrace else {
                XCTFail("Invalid Trace Type")
                return
            }
            XCTAssertEqual(trace, .app_launch)
        }

        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.stopCallCount, 1)

    }

    func test_showMain_displaysChild() {
        let mainViewController = MainViewControllableMock()
        mainViewController.uiviewController = .init()

        XCTAssertEqual(viewController.children.count, 0)

        viewController.showMain(mainViewController)

        XCTAssertEqual(viewController.children.count, 1)
    }
}
