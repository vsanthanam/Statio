//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
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

    func test_didSelectTabBar_callsListener() {
        let bar = UITabBar()
        let item = UITabBarItem(title: nil, image: nil, tag: 7)

        listener.didSelectTabHandler = { tag in
            XCTAssertEqual(tag, item.tag)
        }

        XCTAssertEqual(listener.didSelectTabCallCount, 0)
        viewController.tabBar(bar, didSelect: item)
        XCTAssertEqual(listener.didSelectTabCallCount, 1)
    }
}
