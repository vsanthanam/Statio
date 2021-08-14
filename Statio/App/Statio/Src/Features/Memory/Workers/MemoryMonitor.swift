//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import StatioKit

/// @mockable
protocol MemoryMonitoring: Working {}

final class MemoryMonitor: Worker, MemoryMonitoring {

    // MARK: - Initializers

    init(memoryProvider: MemoryProviding,
         mutableMemorySnapshotStream: MutableMemorySnapshotStreaming) {
        self.memoryProvider = memoryProvider
        self.mutableMemorySnapshotStream = mutableMemorySnapshotStream
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        startTakingMemorySnapshots()
    }

    // MARK: - Private

    private let memoryProvider: MemoryProviding
    private let mutableMemorySnapshotStream: MutableMemorySnapshotStreaming

    private func startTakingMemorySnapshots() {
        let initialSnapshot = try? memoryProvider.record()

        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .tryMap { [memoryProvider] _ -> Memory.Snapshot in
                try memoryProvider.record()
            }
            .replaceError(with: nil)
            .prepend(initialSnapshot)
            .filterNil()
            .removeDuplicates()
            .sink { [mutableMemorySnapshotStream] snapshot in
                mutableMemorySnapshotStream.send(snapshot: snapshot)
            }
            .cancelOnStop(worker: self)
    }
}
