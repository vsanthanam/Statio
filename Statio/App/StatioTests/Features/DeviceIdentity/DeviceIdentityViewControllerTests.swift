//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceIdentityViewControllerTests: TestCase {

    let listener = DeviceIdentityPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()

    var viewController: DeviceIdentityViewController!

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
            XCTAssertEqual(event, .device_identity_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }

    func test_apply_assignsTitle() {
        let model = DeviceIdentityViewModel(deviceName: "Name")
        XCTAssertNil(viewController.title)
        viewController.apply(viewModel: model)
        XCTAssertEqual(viewController.title, "Name")
    }
}
