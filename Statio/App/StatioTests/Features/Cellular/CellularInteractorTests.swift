//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class CellularInteractorTests: TestCase {

    let listener = CellularListenerMock()
    let presenter = CellularPresentableMock()
    var interactor: CellularInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

}
