//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MainDeviceBoardStorageWorking: Working {}

final class MainDeviceBoardStorageWorker: Worker, MainDeviceBoardStorageWorking {

    // MARK: - Initializers

    init(deviceBoardStream: DeviceBoardStreaming,
         mutableDeviceBoardStorage: MutableDeviceBoardStoring) {
        self.deviceBoardStream = deviceBoardStream
        self.mutableDeviceBoardStorage = mutableDeviceBoardStorage
    }

    // MARK: - Worker

    override func didStart(on scope: WorkerScope) {
        super.didStart(on: scope)
        startObservingNewBoards()
    }

    // MARK: - Prviate

    private let deviceBoardStream: DeviceBoardStreaming
    private let mutableDeviceBoardStorage: MutableDeviceBoardStoring

    private func startObservingNewBoards() {
        deviceBoardStream.boards
            .filter { [mutableDeviceBoardStorage] boards in
                boards != (try? mutableDeviceBoardStorage.retrieveCachedBoards()) ?? []

            }
            .removeDuplicates()
            .sink { [mutableDeviceBoardStorage] boards in
                try? mutableDeviceBoardStorage.storeBoards(boards)
            }
            .cancelOnStop(worker: self)

    }
}
