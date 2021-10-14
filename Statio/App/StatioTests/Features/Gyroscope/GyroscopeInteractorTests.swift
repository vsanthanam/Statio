//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class GyroscopeInteractorTests: TestCase {

    let presenter = GyroscopePresentableMock()
    let listener = GyroscopeListenerMock()

    var interactor: GyroscopeInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsPresenter() {
        XCTAssertEqual(listener.gyroscopeDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.gyroscopeDidCloseCallCount, 1)
    }

}
