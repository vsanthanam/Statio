//
// Statio
// Varun Santhanam
//

import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class MonitorListInteractorTests: TestCase {

    let presenter = MonitorListPresentableMock()
    let listener = MonitorListListenerMock()

    var interactor: MonitorListInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_configuresPresenter() {
        presenter.applyIdentifiersHandler = { identifiers, categories in
            XCTAssertEqual(identifiers, MonitorIdentifier.allCases)
            XCTAssertEqual(categories, MonitorCategoryIdentifier.allCases)
        }
        XCTAssertEqual(presenter.applyIdentifiersCallCount, 0)
        interactor.activate()
        XCTAssertEqual(presenter.applyIdentifiersCallCount, 1)
    }

}
