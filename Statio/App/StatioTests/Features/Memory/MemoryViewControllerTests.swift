//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class MemoryViewControllerTests: TestCase {

    let listener = MemoryPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let memoryListCollectionView = MemoryListCollectionViewableMock()
    let memoryListDataSource = MemoryListDataSourceMock()
    let byteFormatter = ByteFormattingMock()

    var viewController: MemoryViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager,
                               memoryListCollectionView: memoryListCollectionView,
                               memoryListDataSource: memoryListDataSource,
                               byteFormatter: byteFormatter)
        viewController.listener = listener
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .memory_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
