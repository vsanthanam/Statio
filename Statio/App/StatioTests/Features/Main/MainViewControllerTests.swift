//
// Aro
// Varun Santhanam
//

@testable import Analytics
@testable import Statio
import Foundation
@testable import ShortRibs
import XCTest

final class MainViewControllerTests: TestCase {

    let analyticsManager = AnalyticsManagingMock()
    let listener = MainPresentableListenerMock()

    var viewController: MainViewController!

    override func setUp() {
        viewController = .init(analyticsManager: analyticsManager)
        viewController.listener = listener
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .main_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
