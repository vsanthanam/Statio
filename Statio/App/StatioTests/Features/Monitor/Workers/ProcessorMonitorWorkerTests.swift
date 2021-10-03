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

final class ProcessorMonitorWorkerTests: TestCase {

    let interactor = Interactor()
    let processorProvider = ProcessorProvidingMock()
    let mutableProcessorSnapshotStream = MutableProcessorSnapshotStreamingMock()

    var worker: ProcessorMonitorWorker!

    override func setUp() {
        super.setUp()
        worker = .init(processorProvider: processorProvider,
                       mutableProcessorSnapshotStream: mutableProcessorSnapshotStream)
        interactor.activate()
    }

    func test_publishes() {
        let testScheduler = DispatchQueue.test
        let subj = PassthroughSubject<ProcessorSnapshot, Never>()
        processorProvider.recordHandler = {
            .test
        }
        mutableProcessorSnapshotStream.sendHandler = { snapshot in
            XCTAssertEqual(snapshot.usage, .test)
            subj.send(snapshot)
        }

        var emits = [ProcessorSnapshot]()

        subj
            .receive(on: testScheduler)
            .sink { value in
                emits.append(value)
            }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(processorProvider.recordCallCount, 0)
        XCTAssertEqual(mutableProcessorSnapshotStream.sendCallCount, 0)
        XCTAssertEqual(emits, [])

        worker.start(on: interactor)

        testScheduler.advance()

        XCTAssertEqual(processorProvider.recordCallCount, 1)
        XCTAssertEqual(mutableProcessorSnapshotStream.sendCallCount, 1)
        XCTAssertEqual(emits.map(\.usage), [.test])
    }

}

private extension Processor.Usage {
    static var test: Processor.Usage {
        .init(usage: [])
    }
}
