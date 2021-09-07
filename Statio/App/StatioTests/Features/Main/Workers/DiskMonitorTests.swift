//
// Statio
// Varun Santhanam
//

import Combine
import CombineSchedulers
import Foundation
import ShortRibs
@testable import Statio
import StatioKit
import XCTest

final class DiskMonitorTests: TestCase {

    let interactor = Interactor()
    let diskProvider = DiskProvidingMock()
    let mutableDiskSnapshotStream = MutableDiskSnapshotStreamingMock()

    var monitor: DiskMonitor!

    override func setUp() {
        super.setUp()
        monitor = .init(diskProvider: diskProvider,
                        mutableDiskSnapshotStream: mutableDiskSnapshotStream)
        interactor.activate()
    }

    func test_publishes() {
        let testScheduler = DispatchQueue.test
        let subj = PassthroughSubject<DiskSnapshot, Never>()
        diskProvider.recordHandler = {
            .test
        }
        mutableDiskSnapshotStream.sendHandler = { snapshot in
            XCTAssertEqual(snapshot.usage, .test)
            subj.send(snapshot)
        }

        var emits = [DiskSnapshot]()

        subj
            .receive(on: testScheduler)
            .sink { value in
                emits.append(value)
            }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(diskProvider.recordCallCount, 0)
        XCTAssertEqual(mutableDiskSnapshotStream.sendCallCount, 0)
        XCTAssertEqual(emits, [])

        monitor.start(on: interactor)

        testScheduler.advance()

        XCTAssertEqual(diskProvider.recordCallCount, 1)
        XCTAssertEqual(mutableDiskSnapshotStream.sendCallCount, 1)
        XCTAssertEqual(emits.map(\.usage), [.test])
    }

}
