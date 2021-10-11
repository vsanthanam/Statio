//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class DeviceModelStorageWorkerTests: TestCase {

    let modelsSubject = PassthroughSubject<[DeviceModel], Never>()
    let deviceModelStream = DeviceModelStreamingMock()
    let mutableDeviceModelStorage = MutableDeviceModelStoringMock()

    var worker: DeviceModelStorageWorker!

    override func setUp() {
        super.setUp()
        deviceModelStream.models = modelsSubject.eraseToAnyPublisher()
        worker = .init(deviceModelStream: deviceModelStream,
                       mutableDeviceModelStorage: mutableDeviceModelStorage)
    }

    func test_newModels_updatesStorage() {
        let interactor = Interactor()
        worker.start(on: interactor)
        interactor.activate()

        XCTAssertEqual(mutableDeviceModelStorage.storeModelsCallCount, 0)

        let newModels = [DeviceModel(name: "m1", identifier: "i1"), DeviceModel(name: "m2", identifier: "i2")]

        mutableDeviceModelStorage.storeModelsHandler = { models in
            XCTAssertEqual(models, newModels)
        }

        modelsSubject.send(newModels)

        XCTAssertEqual(mutableDeviceModelStorage.storeModelsCallCount, 1)
    }

}
