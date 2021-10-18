//
// Statio
// Varun Santhanam
//

import Foundation
@testable import Statio
import XCTest

final class AltimeterInteractorTests: TestCase {

    let listener = AltimeterListenerMock()
    let presenter = AltimeterPresentableMock()

    var interactor: AltimeterInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.altimeterDidCloseCallCount, 0)
        interactor.didTapClose()
        XCTAssertEqual(listener.altimeterDidCloseCallCount, 1)
    }
}
