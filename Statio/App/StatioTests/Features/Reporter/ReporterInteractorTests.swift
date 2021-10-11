//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class ReporterInteractorTests: TestCase {

    let listener = ReporterListenerMock()
    let presenter = ReporterPresentableMock()

    var interactor: ReporterInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }
}
