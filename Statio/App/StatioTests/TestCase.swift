//
// Aro
// Varun Santhanam
//

import Combine
import FBSnapshotTestCase
import Foundation
import XCTest

class TestCase: XCTestCase {

    var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        cancellables.forEach { cancellable in cancellable.cancel() }
        super.tearDown()
    }
}

extension Cancellable {
    func cancelOnTearDown(testCase: TestCase) {
        store(in: &testCase.cancellables)
    }
}

typealias SnapshotTestCase = FBSnapshotTestCase
