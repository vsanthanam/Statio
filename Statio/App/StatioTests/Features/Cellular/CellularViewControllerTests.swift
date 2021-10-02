//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class CellularViewControllerTests: TestCase {

    let analyticsManager = AnalyticsManagingMock()
    let listener = CellularPresentableListenerMock()
    var viewController: CellularViewControler!

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
            XCTAssertEqual(event, .cellular_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
