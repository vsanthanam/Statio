//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import StatioKit
import XCTest

final class BatteryInteractorTests: TestCase {

    let listener = BatteryListenerMock()
    let presenter = BatteryPresentableMock()
    let batteryLevelStream = BatteryLevelStreamingMock()
    let batteryStateStream = BatteryStateStreamingMock()

    var interactor: BatteryInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           batteryLevelStream: batteryLevelStream,
                           batteryStateStream: batteryStateStream)
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

    func test_levelUpdate_callsPresenter() {
        presenter.updateHandler = { level in
            XCTAssertEqual(level, 0.5)
        }

        XCTAssertEqual(presenter.updateCallCount, 0)

        interactor.activate()

        XCTAssertEqual(presenter.updateCallCount, 0)

        batteryLevelStream.batteryLevelSubject.send(0.5)

        XCTAssertEqual(presenter.updateCallCount, 1)
    }

    func test_stateUpdate_callsPresenter() {
        presenter.updateStateHandler = { state in
            XCTAssertEqual(state, .charging)
        }

        XCTAssertEqual(presenter.updateStateCallCount, 0)

        interactor.activate()

        XCTAssertEqual(presenter.updateStateCallCount, 0)

        batteryStateStream.batteryStateSubject.send(.charging)

        XCTAssertEqual(presenter.updateStateCallCount, 1)
    }
}
