//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import StatioKit
@testable import StatioMocks
import XCTest

final class MemorySnapshotStreamTests: TestCase {

    var memorySnapshotStream: MemorySnapshotStream!

    override func setUp() {
        super.setUp()
        memorySnapshotStream = .init()
    }

    func test_send_emits() {
        var emits = [MemorySnapshot]()
        memorySnapshotStream.snapshots
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

extension MemorySnapshot {
    static var test: MemorySnapshot {
        .init(usage: .init(physical: 0, free: 0, active: 0, inactive: 0, wired: 0, pageIns: 0, pageOuts: 0),
              timestamp: .distantPast)
    }
}

extension Memory.Usage {
    static var test: Memory.Usage {
        .init(physical: 0, free: 0, active: 0, inactive: 0, wired: 0, pageIns: 0, pageOuts: 0)
    }
}
