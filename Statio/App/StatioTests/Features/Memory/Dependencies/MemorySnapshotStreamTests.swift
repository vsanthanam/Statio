//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import StatioKit
import XCTest

final class MemorySnapshotStreamTests: TestCase {

    var memorySnapshotStream: MemorySnapshotStream!

    override func setUp() {
        super.setUp()
        memorySnapshotStream = .init()
    }

    func test_send_emits() {
        var emits = [Memory.Snapshot]()
        memorySnapshotStream.memorySnapshot
            .sink { snapshot in
                emits.append(snapshot)
            }
            .cancelOnTearDown(testCase: self)
        XCTAssertEqual(emits.count, 0)
        memorySnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 1)
        memorySnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 2)
        memorySnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 3)
        XCTAssertEqual(emits, [.test, .test, .test])
    }

}

extension Memory.Snapshot {
    static var test: Memory.Snapshot {
        .init(physical: 0, free: 0, active: 0, inactive: 0, wired: 0, pageIns: 0, pageOuts: 0)
    }
}
