//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class WiFiInteractorTests: TestCase {

    let presenter = WiFiPresentableMock()
    let listener = WiFiListenerMock()

    var interactor: WiFiInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.wifiDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.wifiDidCloseCallCount, 1)
    }
}
