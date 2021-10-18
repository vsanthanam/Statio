//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import UIKit
import XCTest

final class CompassViewControllerTests: TestCase {

    let listener = CompassPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()

    var viewController: CompassViewController!

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
            XCTAssertEqual(event, .compass_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
