//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import Logging
import Ombi
import os.log
import ShortRibs

/// @CreateMock
protocol DeviceBoardUpdateWorking: Working {}

final class DeviceBoardUpdateWorker: Worker, DeviceBoardUpdateWorking {

    // MARK: - Initializers

    init(mutableDeviceBoardStream: MutableDeviceBoardStreaming,
         deviceBoardUpdateProvider: DeviceBoardUpdateProviding) {
        self.mutableDeviceBoardStream = mutableDeviceBoardStream
        self.deviceBoardUpdateProvider = deviceBoardUpdateProvider
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        updateBoards()
    }

    // MARK: - Private

    private let mutableDeviceBoardStream: MutableDeviceBoardStreaming
    private let deviceBoardUpdateProvider: DeviceBoardUpdateProviding

    private func updateBoards() {
        ComposableRequest<NoBody, [DeviceBoard], HTTPError>()
            .path(deviceBoardUpdateProvider.path)
            .method(.get)
            .send(on: deviceBoardUpdateProvider.host, retries: 1, sla: 20)
            .map(\.body)
            .removeDuplicates()
            .filterNil()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    os_log(.error, log: .standard, "Failed to update boards: %@", error.localizedDescription)
                case .finished:
                    os_log(.info, log: .standard, "Retrieved latest boards")
                }
            } receiveValue: { [mutableDeviceBoardStream] boards in
                mutableDeviceBoardStream.update(boards: boards)
            }
            .cancelOnStop(worker: self)
    }

}
