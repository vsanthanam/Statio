//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class MonitorInteractorTests: TestCase {

    let presenter = MonitorPresentableMock()
    let listener = MonitorListenerMock()
    let monitorListBuilder = MonitorListBuildableMock()

    var interactor: MonitorInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter, monitorListBuilder: monitorListBuilder)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_buildsAndPresents_monitorList() {
        monitorListBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return MonitorListInteractableMock()
        }

        XCTAssertEqual(monitorListBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showListCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorListBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showListCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

}
