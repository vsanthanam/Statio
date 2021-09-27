//
// Statio
// Varun Santhanam
//

import ShortRibs
@testable import Statio
import XCTest

final class ProcessorInteractorTests: TestCase {

    let listener = ProcessorListenerMock()
    let presenter = ProcessorPresentableMock()

    var interactor: ProcessorInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
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
}
