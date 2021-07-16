//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class MemoryInteractorTests: TestCase {

    let listener = MemoryListenerMock()
    let presenter = MemoryPresentableMock()
    let memoryMonitor = MemoryMonitoringMock()
    let snapshotSubject = PassthroughSubject<MemoryMonitor.Snapshot, Never>()
    let memorySnapshotStream = MemorySnapshotStreamingMock()

    var interactor: MemoryInteractor!

    override func setUp() {
        super.setUp()
        memorySnapshotStream.memorySnapshot = snapshotSubject.eraseToAnyPublisher()
        interactor = .init(presenter: presenter,
                           memoryMonitor: memoryMonitor,
                           memorySnapshotStream: memorySnapshotStream)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_didBecomeActive_startsMemoryMonitor() {
        memoryMonitor.startHandler = { [interactor] scope in
            XCTAssertTrue(interactor === scope)
        }
        XCTAssertEqual(memoryMonitor.startCallCount, 0)
        interactor.activate()
        XCTAssertEqual(memoryMonitor.startCallCount, 1)
    }

    func test_newSnapshot_callsPresenter() {
        interactor.activate()
        presenter.presentHandler = { snapshot in
            XCTAssertEqual(snapshot, .test)
        }
        XCTAssertEqual(presenter.presentCallCount, 0)
        snapshotSubject.send(.test)
        XCTAssertEqual(presenter.presentCallCount, 1)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.memoryDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.memoryDidCloseCallCount, 1)
    }
}
