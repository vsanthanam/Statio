//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import MonitorKit
@testable import ShortRibs
@testable import Statio
import XCTest

final class MemoryInteractorTests: TestCase {

    let listener = MemoryListenerMock()
    let presenter = MemoryPresentableMock()
    let memorySnapshotStream = MemorySnapshotStreamingMock()

    var interactor: MemoryInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           memorySnapshotStream: memorySnapshotStream)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_newSnapshot_callsPresenter() {
        interactor.activate()
        presenter.presentHandler = { snapshot in
            XCTAssertEqual(snapshot, .test)
        }
        XCTAssertEqual(presenter.presentCallCount, 0)
        memorySnapshotStream.snapshotsSubject.send(.test)
        XCTAssertEqual(presenter.presentCallCount, 1)
        memorySnapshotStream.snapshotsSubject.send(.test)
        XCTAssertEqual(presenter.presentCallCount, 1)

        let newSnapshot = MemorySnapshot(usage: .init(physical: 1, free: 1, active: 1, inactive: 1, wired: 1, pageIns: 1, pageOuts: 1), timestamp: .distantPast)

        presenter.presentHandler = { snapshot in
            XCTAssertEqual(snapshot, newSnapshot)
        }

        memorySnapshotStream.snapshotsSubject.send(newSnapshot)
        XCTAssertEqual(presenter.presentCallCount, 2)
    }

    func test_didTapBack_callsListener() {
        XCTAssertEqual(listener.memoryDidCloseCallCount, 0)
        interactor.didTapBack()
        XCTAssertEqual(listener.memoryDidCloseCallCount, 1)
    }
}
