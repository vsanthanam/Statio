//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
@testable import StatioKit
import XCTest

final class ProcessorSnapshotStreamTests: TestCase {

    var stream: ProcessorSnapshotStream!

    override func setUp() {
        stream = .init()
        super.setUp()
    }

    func test_update_sends_value() {
        var emits = [ProcessorSnapshot]()
        stream.snapshots
            .sink { emits.append($0) }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(emits, [])

        let snapshot = ProcessorSnapshot(usage: .init(usage: []), timestamp: .distantFuture)

        stream.update(snapshot: snapshot)

        XCTAssertEqual(emits, [snapshot])
    }

}
