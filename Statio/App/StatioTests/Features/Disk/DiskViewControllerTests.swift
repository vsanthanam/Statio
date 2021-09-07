//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DiskViewControllerTests: TestCase {

    let listener = DiskPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let byteFormatter = ByteFormattingMock()

    var viewController: DiskViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager,
                               byteFormatter: byteFormatter)
        viewController.listener = listener
    }

    func test_viewDidLoad_setsTitle() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.title, "Disk")
    }
}
