//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class AccelerometerInteractorTests: TestCase {

    let listener = AccelerometerListenerMock()
    let presenter = AccelerometerPresentableMock()

    var interactor: AccelerometerInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.accelerometerDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.accelerometerDidCloseCallCount, 1)
    }

}
