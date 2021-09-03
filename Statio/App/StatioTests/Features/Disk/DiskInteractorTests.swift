//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DiskInteractorTests: TestCase {

    let listener = DiskListenerMock()
    let presenter = DiskPresentableMock()
    let analyticsManager = AnalyticsManagingMock()

    var interactor: DiskInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssert(presenter.listener === interactor)
    }
}
