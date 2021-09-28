//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class ProcessorViewControllerTests: TestCase {

    let listener = ProcessorPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()

    var viewController: ProcessorViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager)
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .processor_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }

    func test_didTapBack_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .processor_vc_dismiss)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.perform(NSSelectorFromString("didTapBack"))
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
