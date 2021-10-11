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
@testable import StatioMocks
import XCTest

final class MemoryMonitorTests: TestCase {

    let interactor = Interactor()
    let memoryProvider = MemoryProvidingMock()
    let mutableMemorySnapshotStream = MutableMemorySnapshotStreamingMock()

    var monitor: MemoryMonitorWorker!

    override func setUp() {
        super.setUp()
        monitor = .init(memoryProvider: memoryProvider,
                        mutableMemorySnapshotStream: mutableMemorySnapshotStream)
        interactor.activate()
    }

    func test_publishes() {
        let testScheduler = DispatchQueue.test
        let subj = PassthroughSubject<MemorySnapshot, Never>()
        memoryProvider.recordHandler = {
            .test
        }
        mutableMemorySnapshotStream.sendHandler = { snapshot in
            XCTAssertEqual(snapshot.usage, .test)
            subj.send(snapshot)
        }

        var emits = [MemorySnapshot]()

        subj
            .receive(on: testScheduler)
            .sink { value in
                emits.append(value)
            }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(memoryProvider.recordCallCount, 0)
        XCTAssertEqual(mutableMemorySnapshotStream.sendCallCount, 0)
        XCTAssertEqual(emits, [])

        monitor.start(on: interactor)

        testScheduler.advance()

        XCTAssertEqual(memoryProvider.recordCallCount, 1)
        XCTAssertEqual(mutableMemorySnapshotStream.sendCallCount, 1)
        XCTAssertEqual(emits.map(\.usage), [.test])
    }

}
