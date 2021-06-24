//
// Statio
// Varun Santhanam
//

import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class RootInteractorTests: TestCase {

    let presenter = RootPresentableMock()
    let analyticsManager = AnalyticsManagingMock()
    let mainBuilder = MainBuildableMock()

    var interactor: RootInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           analyticsManager: analyticsManager,
                           mainBuilder: mainBuilder)
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_attachesChild() {
        let main = PresentableInteractableMock()
        let viewController = ViewControllableMock()
        main.viewControllable = viewController

        mainBuilder.buildHandler = { listener in
            XCTAssertTrue(listener === self.interactor)
            return main
        }

        presenter.showMainHandler = { vc in
            XCTAssertTrue(vc === viewController)
        }

        XCTAssertEqual(mainBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMainCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(mainBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMainCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_activate_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .root_become_active)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        interactor.activate()
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }
}
