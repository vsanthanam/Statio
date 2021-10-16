//
// Statio
// Varun Santhanam
//

import Foundation
@testable import Statio
import XCTest

final class MagnometerInteractorTests: TestCase {

    let listener = MagnometerListenerMock()
    let presenter = MagnometerPresentableMock()

    var interactor: MagnometerInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }
}
