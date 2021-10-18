//
// Statio
// Varun Santhanam
//

import Foundation
@testable import Statio
import XCTest

final class MapInteractorTests: TestCase {

    let listener = MapListenerMock()
    let presenter = MapPresentableMock()

    var interactor: MapInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.mapDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.mapDidCloseCallCount, 1)
    }

}
