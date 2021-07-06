//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import Statio
import XCTest

final class MonitorInteractorTests: TestCase {

    let presenter = MonitorPresentableMock()
    let listener = MonitorListenerMock()
    let monitorListBuilder = MonitorListBuildableMock()
    let deviceIdentityBuilder = DeviceIdentityBuildableMock()

    var interactor: MonitorInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter,
                           monitorListBuilder: monitorListBuilder,
                           deviceIdentityBuilder: deviceIdentityBuilder)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_activate_buildsAndPresents_monitorList() {
        monitorListBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return MonitorListInteractableMock()
        }

        XCTAssertEqual(monitorListBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showListCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()

        XCTAssertEqual(monitorListBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showListCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

    func test_didSelect_deviceIdentity_buildsAttachesAndPresents() {
        let viewController = ViewControllableMock()
        let deviceIdentity = PresentableInteractableMock()
        deviceIdentity.viewControllable = viewController

        deviceIdentityBuilder.buildHandler = { [interactor] listener in
            XCTAssertTrue(interactor === listener)
            return deviceIdentity
        }

        XCTAssertEqual(deviceIdentityBuilder.buildCallCount, 0)
        XCTAssertEqual(presenter.showMonitorCallCount, 0)
        XCTAssertEqual(interactor.children.count, 0)

        interactor.activate()
        if let list = interactor.children.first as? MonitorListInteractableMock {
            list.isActive = true
        }
        interactor.monitorListDidSelect(identifier: .identity)

        XCTAssertEqual(deviceIdentityBuilder.buildCallCount, 1)
        XCTAssertEqual(presenter.showMonitorCallCount, 1)
        XCTAssertEqual(interactor.children.count, 1)
    }

}
