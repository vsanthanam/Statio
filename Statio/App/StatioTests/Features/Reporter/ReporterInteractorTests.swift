//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import XCTest

final class ReporterInteractorTests: TestCase {

    let presenter = ReporterPresentableMock()

    var interactor: ReporterInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }
}
