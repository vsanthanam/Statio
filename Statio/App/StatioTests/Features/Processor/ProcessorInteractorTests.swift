//
// Statio
// Varun Santhanam
//

import Combine
import ShortRibs
@testable import Statio
import XCTest

final class ProcessorInteractorTests: TestCase {

    let listener = ProcessorListenerMock()
    let presenter = ProcessorPresentableMock()
    let subject = PassthroughSubject<ProcessorSnapshot, Never>()
    let processorSnapshotStream = ProcessorSnapshotStreamingMock()

    var interactor: ProcessorInteractor!

    override func setUp() {
        super.setUp()
        processorSnapshotStream.snapshots = subject.eraseToAnyPublisher()
        interactor = .init(presenter: presenter,
                           processorSnapshotStream: processorSnapshotStream)
        interactor.listener = listener
    }

    func test_init_sets_presenter_listener() {
        XCTAssertTrue(interactor === presenter.listener)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.processorDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.processorDidCloseCallCount, 1)
    }

    func test_snapshotStream_callsPresent() {
        let snapshot = ProcessorSnapshot(usage: .init(usage: []), timestamp: .distantFuture)
        presenter.presentHandler = { s in
            XCTAssertEqual(s, snapshot)
        }
        interactor.activate()
        XCTAssertEqual(presenter.presentCallCount, 0)
        subject.send(snapshot)
        XCTAssertEqual(presenter.presentCallCount, 1)
    }
}
