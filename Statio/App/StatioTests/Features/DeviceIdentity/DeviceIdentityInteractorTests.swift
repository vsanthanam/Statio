//
// Statio
// Varun Santhanam
//

import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceIdentityInteractorTests: TestCase {

    let listener = DeviceIdentityListenerMock()
    let presenter = DeviceIdentityPresentableMock()
    let deviceNameProvider = DeviceNameProvidingMock()

    var interactor: DeviceIdentityInteractor!

    override func setUp() {
        super.setUp()
        interactor = .init(presenter: presenter, deviceNameProvider: deviceNameProvider)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_appliesViewModel_onActivate() {
        deviceNameProvider.buildLatestNameHandler = {
            "Name"
        }

        presenter.applyHandler = { viewModel in
            XCTAssertEqual(viewModel.deviceName, "Name")
        }

        XCTAssertEqual(deviceNameProvider.buildLatestNameCallCount, 0)
        XCTAssertEqual(presenter.applyCallCount, 0)

        interactor.activate()

        XCTAssertEqual(deviceNameProvider.buildLatestNameCallCount, 1)
        XCTAssertEqual(presenter.applyCallCount, 1)
    }

    func test_appliesViewModel_onNotification() {
        deviceNameProvider.buildLatestNameHandler = {
            "Name"
        }

        XCTAssertEqual(deviceNameProvider.buildLatestNameCallCount, 0)
        XCTAssertEqual(presenter.applyCallCount, 0)

        interactor.activate()

        deviceNameProvider.buildLatestNameHandler = {
            "Name2"
        }

        presenter.applyHandler = { viewModel in
            XCTAssertEqual(viewModel.deviceName, "Name2")
        }

        NotificationCenter.default.post(.init(name: UIApplication.didBecomeActiveNotification))

        XCTAssertEqual(deviceNameProvider.buildLatestNameCallCount, 2)
        XCTAssertEqual(presenter.applyCallCount, 2)
    }
}
