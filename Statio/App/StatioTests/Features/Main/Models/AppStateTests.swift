//
// Statio
// Varun Santhanam
//

import Foundation
@testable import Statio
import XCTest

final class AppStateTests: TestCase {

    func test_allStates_uniqueIdentifiers() {
        XCTAssertEqual(Set(AppState.allCases.map(\.id)).count, AppState.allCases.map(\.id).count)
    }

}