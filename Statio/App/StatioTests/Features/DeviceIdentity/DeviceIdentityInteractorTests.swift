//
// Statio
// Varun Santhanam
//

import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceIdentityInteractorTests: TestCase {

    let listener = DeviceIdentityListenerMock()
    let presenter = DeviceIdentityPresentableMock()

    var interactor: DeviceIdentityInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }
}
