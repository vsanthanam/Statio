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

/// @mockable
protocol MainDeviceBoardUpdateWorking: Working {}

final class MainDeviceBoardUpdateWorker: Worker, MainDeviceBoardUpdateWorking {

    // MARK: - Initializers

    init(mutableDeviceBoardStream: MutableDeviceBoardStreaming) {
        self.mutableDeviceBoardStream = mutableDeviceBoardStream
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: WorkerScope) {
        super.didStart(on: scope)
        updateBoards()
    }

    // MARK: - Private

    private let mutableDeviceBoardStream: MutableDeviceBoardStreaming

    private func updateBoards() {
        ComposableRequest<NoBody, [DeviceBoard], HTTPError>()
            .path("/statio-device-list/boards.json")
            .method(.get)
            .send(on: "https://vsanthanam.github.io")
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
