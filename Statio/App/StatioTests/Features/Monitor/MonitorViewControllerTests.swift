//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import Statio
@testable import StatioMocks
import XCTest

final class MonitorViewControllerTests: TestCase {

    let analyticsManager = AnalyticsManagingMock()
    let listener = MonitorPresentableListenerMock()

    var viewController: MonitorViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager)
        viewController.listener = listener
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .monitor_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
