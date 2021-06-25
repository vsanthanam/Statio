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
protocol MainDeviceModelUpdateWorking: Working {}

final class MainDeviceModelUpdateWorker: Worker, MainDeviceModelUpdateWorking {

    // MARK: - Initializers

    init(mutableDeviceModelStream: MutableDeviceModelStreaming) {
        self.mutableDeviceModelStream = mutableDeviceModelStream
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: WorkerScope) {
        super.didStart(on: scope)
        updateModels()
    }

    // MARK: - Private

    private let mutableDeviceModelStream: MutableDeviceModelStreaming

    private func updateModels() {
        ComposableRequest<NoBody, [DeviceModel], HTTPError>()
            .path("/statio-device-list/models.json")
            .method(.get)
            .send(on: "https://vsanthanam.github.io", retries: 1, sla: 20)
            .map(\.body)
            .removeDuplicates()
            .filterNil()
            .sink { completion in
                switch completion {
                case let .failure(error):
                    os_log(.error, log: .standard, "Failed to update models: %@", error.localizedDescription)
                case .finished:
                    os_log(.info, log: .standard, "Retrieved latest models")
                }
            } receiveValue: { [mutableDeviceModelStream] models in
                mutableDeviceModelStream.update(models: models)
            }
            .cancelOnStop(worker: self)
    }
}
