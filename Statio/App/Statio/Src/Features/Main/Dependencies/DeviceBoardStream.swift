//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @mockable
protocol DeviceBoardStreaming: AnyObject {
    var boards: AnyPublisher<[DeviceBoard], Never> { get }
}

/// @mockable
protocol MutableDeviceBoardStreaming: DeviceBoardStreaming {
    func update(boards: [DeviceBoard])
}

final class DeviceBoardStream: MutableDeviceBoardStreaming {

    init(deviceBoardStorage: DeviceBoardStoring) {
        self.deviceBoardStorage = deviceBoardStorage
    }

    // MARK: - DeviceBoardStreaming

    var boards: AnyPublisher<[DeviceBoard], Never> {
        subject
            .prepend((try? deviceBoardStorage.retrieveCachedBoards()) ?? [])
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableDeviceBoardStreaming

    func update(boards: [DeviceBoard]) {
        subject.send(boards)
    }

    // MARK: - Private

    private let subject = ReplaySubject<[DeviceBoard], Never>(bufferSize: 1)
    private let deviceBoardStorage: DeviceBoardStoring
}
