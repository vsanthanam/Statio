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

final class DiskInteractorTests: TestCase {

    let listener = DiskListenerMock()
    let presenter = DiskPresentableMock()
    let analyticsManager = AnalyticsManagingMock()
    let diskSnapshotStream = DiskSnapshotStreamingMock()

    var interactor: DiskInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           diskSnapshotStream: diskSnapshotStream)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssert(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.diskDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.diskDidCloseCallCount, 1)
    }
}
