//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import StatioKit

/// @mockable
protocol MemoryMonitorWorking: Working {}

final class MemoryMonitorWorker: Worker, MemoryMonitorWorking {

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
        let initialSnapshot: MemorySnapshot? = {
            guard let usage = try? memoryProvider.record() else {
                return nil
            }
            return MemorySnapshot(usage: usage, timestamp: .init())
        }()

        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .tryMap { [memoryProvider] timestamp -> MemorySnapshot in
                let usage = try memoryProvider.record()
                return MemorySnapshot(usage: usage, timestamp: timestamp)
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
