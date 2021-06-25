//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceModelStreamTests: TestCase {

    let deviceModelStorage = DeviceModelStoringMock()

    var stream: DeviceModelStream!

    override func setUp() {
        super.setUp()
        stream = .init(deviceModelStorage: deviceModelStorage)
    }

    func test_subscribe_loadsFromStorage_filtersDuplicates() {
        let storedModels = [DeviceModel(name: "m1", identifier: "i1"), DeviceModel(name: "m2", identifier: "i2")]

        var emits = [[DeviceModel]]()

        deviceModelStorage.retrieveCachedModelsHandler = {
            storedModels
        }

        stream.models
            .sink { models in emits.append(models) }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(deviceModelStorage.retrieveCachedModelsCallCount, 1)

        XCTAssertEqual(emits, [storedModels])

        stream.update(models: storedModels)

        XCTAssertEqual(emits, [storedModels])
    }

    func test_subscribe_loadsFromStorage_replacesNewValues() {
        let storedModels = [DeviceModel(name: "m1", identifier: "i1"), DeviceModel(name: "m2", identifier: "i2")]
        let newModels = [DeviceModel(name: "m3", identifier: "i3"), DeviceModel(name: "m4", identifier: "i4")]

        var emits = [[DeviceModel]]()

        deviceModelStorage.retrieveCachedModelsHandler = {
            storedModels
        }

        stream.models
            .sink { models in emits.append(models) }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(deviceModelStorage.retrieveCachedModelsCallCount, 1)

        XCTAssertEqual(emits, [storedModels])

        stream.update(models: newModels)

        XCTAssertEqual(emits, [storedModels, newModels])
    }
}
