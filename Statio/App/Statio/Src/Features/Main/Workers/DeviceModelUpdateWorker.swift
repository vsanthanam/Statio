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
protocol DeviceModelUpdateWorking: Working {}

final class DeviceModelUpdateWorker: Worker, DeviceModelUpdateWorking {

    // MARK: - Initializers

    init(mutableDeviceModelStream: MutableDeviceModelStreaming,
         deviceModelUpdateProvider: DeviceModelUpdateProviding) {
        self.mutableDeviceModelStream = mutableDeviceModelStream
        self.deviceModelUpdateProvider = deviceModelUpdateProvider
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        updateModels()
    }

    // MARK: - Private

    private let mutableDeviceModelStream: MutableDeviceModelStreaming
    private let deviceModelUpdateProvider: DeviceModelUpdateProviding

    private func updateModels() {
        ComposableRequest<NoBody, [DeviceModel], HTTPError>()
            .path(deviceModelUpdateProvider.path)
            .method(.get)
            .send(on: deviceModelUpdateProvider.host, retries: 1, sla: 20)
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
