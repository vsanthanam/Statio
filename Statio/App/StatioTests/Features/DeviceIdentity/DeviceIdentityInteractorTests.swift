//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceIdentityInteractorTests: TestCase {

    let listener = DeviceIdentityListenerMock()
    let presenter = DeviceIdentityPresentableMock()
    let deviceStaticInfoProvider = DeviceStaticInfoProvidingMock()
    let deviceModelSubject = PassthroughSubject<[DeviceModel], Never>()
    let deviceModelStream = DeviceModelStreamingMock()

    var interactor: DeviceIdentityInteractor!

    override func setUp() {
        super.setUp()
        deviceModelStream.models = deviceModelSubject.eraseToAnyPublisher()
        interactor = .init(presenter: presenter, deviceStaticInfoProvider: deviceStaticInfoProvider, deviceModelStream: deviceModelStream)
        interactor.listener = listener
    }

    func test_init_assigns_presenter_listener() {
        XCTAssertTrue(presenter.listener === interactor)
    }

    func test_appliesViewModel_onActivate() {
        deviceStaticInfoProvider.deviceName = "Name"
        deviceStaticInfoProvider.modelIdentifier = "x86_64"

        presenter.applyHandler = { viewModel in
            XCTAssertEqual(viewModel.deviceName, "Name")
            XCTAssertEqual(viewModel.modelIdentifier, "x86_64")
            XCTAssertEqual(viewModel.modelName, "Unknown Model")
        }

        XCTAssertEqual(presenter.applyCallCount, 0)
        interactor.activate()
        deviceModelSubject.send([])
        XCTAssertEqual(presenter.applyCallCount, 1)
    }

    func test_appliesViewModel_onNewModel_onNewNotification() {
        deviceStaticInfoProvider.deviceName = "Name"
        deviceStaticInfoProvider.modelIdentifier = "x86_64"

        XCTAssertEqual(presenter.applyCallCount, 0)

        interactor.activate()
        deviceModelSubject.send([])

        deviceStaticInfoProvider.deviceName = "Name2"
        deviceStaticInfoProvider.modelIdentifier = "x86_64"

        presenter.applyHandler = { viewModel in
            XCTAssertEqual(viewModel.deviceName, "Name2")
            XCTAssertEqual(viewModel.modelIdentifier, "x86_64")
            XCTAssertEqual(viewModel.modelName, "Simulator")
        }

        deviceModelSubject.send([.init(name: "Simulator", identifier: "x86_64")])

        XCTAssertEqual(presenter.applyCallCount, 2)

        deviceStaticInfoProvider.deviceName = "Device3"

        presenter.applyHandler = { viewModel in
            XCTAssertEqual(viewModel.deviceName, "Device3")
            XCTAssertEqual(viewModel.modelIdentifier, "x86_64")
            XCTAssertEqual(viewModel.modelName, "Simulator")
        }

        NotificationCenter.default.post(.init(name: UIApplication.didBecomeActiveNotification))

        XCTAssertEqual(presenter.applyCallCount, 3)
    }
}
