//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MainDeviceModelStorageWorking: Working {}

final class MainDeviceModelStorageWorker: Worker, MainDeviceModelStorageWorking {

    // MARK: - Initializers

    init(deviceModelStream: DeviceModelStreaming,
         mutableDeviceModelStorage: MutableDeviceModelStoring) {
        self.deviceModelStream = deviceModelStream
        self.mutableDeviceModelStorage = mutableDeviceModelStorage
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: WorkerScope) {
        super.didStart(on: scope)
        startObservingNewModels()
    }

    // MARK: - Private

    private let deviceModelStream: DeviceModelStreaming
    private let mutableDeviceModelStorage: MutableDeviceModelStoring

    private func startObservingNewModels() {
        deviceModelStream
            .models
            .filter { [mutableDeviceModelStorage] models in
                models != (try? mutableDeviceModelStorage.retrieveCachedModels()) ?? []
            }
            .removeDuplicates()
            .sink { [mutableDeviceModelStorage] models in
                try? mutableDeviceModelStorage.storeModels(models)
            }
            .cancelOnStop(worker: self)
    }
}
