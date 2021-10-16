//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class SettingsInteractorTests: TestCase {

    let presenter = SettingsPresentableMock()

    var interactor: SettingsInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

}
