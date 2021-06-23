//
// Aro
// Varun Santhanam
//

@testable import Statio
import Combine
import Foundation
@testable import ShortRibs
import XCTest

final class MainInteractorTests: TestCase {

    let presenter = MainPresentableMock()
    let listener = MainListenerMock()

    var interactor: MainInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter)
        interactor.listener = listener
    }

    func test_init_setsPresenterListener() {
        XCTAssertTrue(presenter.listener === interactor)
    }
    
}
