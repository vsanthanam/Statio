//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import MonitorKit
@testable import Statio
import XCTest

final class DiskSnapshotStreamTests: TestCase {

    var diskSnapshotStream: DiskSnapshotStream!

    override func setUp() {
        super.setUp()
        diskSnapshotStream = .init()
    }

    func test_send_emits() {
        var emits = [DiskSnapshot]()
        diskSnapshotStream.snapshots
            .sink { snapshot in
                emits.append(snapshot)
            }
            .cancelOnTearDown(testCase: self)
        XCTAssertEqual(emits.count, 0)
        diskSnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 1)
        diskSnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 2)
        diskSnapshotStream.send(snapshot: .test)
        XCTAssertEqual(emits.count, 3)
        XCTAssertEqual(emits, [.test, .test, .test])
    }

}

extension DiskSnapshot {
    static var test: DiskSnapshot {
        .init(usage: .test,
              timestamp: .distantPast)
    }
}

extension Disk.Usage {
    static var test: Disk.Usage {
        .init(total: 0, opportunisticAvailable: 0, importantAvailable: 0, available: 0)
    }
}
