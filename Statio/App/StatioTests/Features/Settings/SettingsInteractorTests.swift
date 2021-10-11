//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
@testable import StatioMocks
import XCTest

final class SettingsInteractorTests: TestCase {

    let presenter = SettingsPresentableMock()
    let listener = SettingsListenerMock()

    var interactor: SettingsInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

}
