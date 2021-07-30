//
// Statio
// Varun Santhanam
//

import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class BatteryInteractorTests: TestCase {

    let listener = BatteryListenerMock()
    let presenter = BatteryPresentableMock()

    var interactor: BatteryInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.batteryDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.batteryDidCloseCallCount, 1)
    }
}
