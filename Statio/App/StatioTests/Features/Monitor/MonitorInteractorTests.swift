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

    var interactor: MonitorInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

}
