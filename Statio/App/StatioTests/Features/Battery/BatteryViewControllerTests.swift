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

final class BatteryViewControllerTests: TestCase {

    let listener = BatteryPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let collectionView = BatteryCollectionViewableMock()
    let dataSource = BatteryDataSourceMock()

    var viewController: BatteryViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager,
                               collectionView: collectionView,
                               dataSource: dataSource)
        viewController.listener = listener
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .battery_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }

    func test_updateBatteryLevel_callsDataSource() {
        XCTAssertEqual(dataSource.applyCallCount, 0)
        viewController.update(level: 0.0)
        XCTAssertEqual(dataSource.applyCallCount, 1)
    }

    func test_updateBatteryState_callsDataSource() {
        XCTAssertEqual(dataSource.applyCallCount, 0)
        viewController.update(state: .discharging)
        XCTAssertEqual(dataSource.applyCallCount, 1)
    }
}
