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

    init(mutableMemorySnapshotStream: MutableMemorySnapshotStreaming) {
        self.mutableMemorySnapshotStream = mutableMemorySnapshotStream
        super.init()
    }

    // MARK: - API

    struct Snapshot: Equatable, Hashable {
        let data: Memory.Snapshot
        let timestamp: Date
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        beginTakingMemorySnapshots()
    }

    // MARK: - Private

    private let mutableMemorySnapshotStream: MutableMemorySnapshotStreaming

    private func beginTakingMemorySnapshots() {
        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .tryMap { date -> Snapshot in
                let data = try Memory.record()
                return Snapshot(data: data, timestamp: date)
            }
            .replaceError(with: nil)
            .filterNil()
            .removeDuplicates()
            .sink { [mutableMemorySnapshotStream] snapshot in
                mutableMemorySnapshotStream.send(snapshot: snapshot)
            }
            .cancelOnStop(worker: self)
    }
}
