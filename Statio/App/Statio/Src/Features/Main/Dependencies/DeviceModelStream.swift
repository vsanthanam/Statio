//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @CreateMock
public protocol DeviceModelStreaming: AnyObject {
    var models: AnyPublisher<[DeviceModel], Never> { get }
}

/// @CreateMock
public protocol MutableDeviceModelStreaming: DeviceModelStreaming {
    func update(models: [DeviceModel])
}

final class DeviceModelStream: MutableDeviceModelStreaming {

    // MARK: - Initializers

    init(deviceModelStorage: DeviceModelStoring) {
        self.deviceModelStorage = deviceModelStorage
    }

    // MARK: - DeviceModelStreaming

    var models: AnyPublisher<[DeviceModel], Never> {
        subject
            .prepend((try? deviceModelStorage.retrieveCachedModels()) ?? [])
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableDeviceModelStreaming

    func update(models: [DeviceModel]) {
        subject.send(models)
    }

    // MARK: - Private

    private let subject = ReplaySubject<[DeviceModel], Never>(bufferSize: 1)
    private let deviceModelStorage: DeviceModelStoring
}
