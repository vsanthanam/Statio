//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class AppStateManagerTests: TestCase {

    var manager: AppStateManager!

    override func setUp() {
        super.setUp()
        manager = .init()
    }

    func test_publishesState_ignoresDuplicates() {
        var emits = [AppState]()

        manager.state
            .sink { state in
                emits.append(state)
            }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(emits, [])

        manager.update(state: .monitor)

        XCTAssertEqual(emits, [.monitor])

        manager.update(state: .monitor)

        XCTAssertEqual(emits, [.monitor])

        manager.update(state: .settings)

        XCTAssertEqual(emits, [.monitor, .settings])

        manager.update(state: .monitor)

        XCTAssertEqual(emits, [.monitor, .settings, .monitor])
    }

}
