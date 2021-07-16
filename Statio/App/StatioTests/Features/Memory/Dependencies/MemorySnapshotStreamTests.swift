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
        var emits = [MemoryMonitor.Snapshot]()
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

extension MemoryMonitor.Snapshot {
    static var test: MemoryMonitor.Snapshot {
        .init(data: .init(physicalMemory: 0, freeMemory: 0, active: 0, inactive: 0, wired: 0, pageIns: 0, pageOuts: 0), timestamp: .distantPast)
    }
}
