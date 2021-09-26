//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import ShortRibs

/// @mockable
protocol DiskMonitorWorking: Working {}

final class DiskMonitorWorker: Worker, DiskMonitorWorking {

    // MARK: - Initializers

    init(diskProvider: DiskProviding,
         mutableDiskSnapshotStream: MutableDiskSnapshotStreaming) {
        self.diskProvider = diskProvider
        self.mutableDiskSnapshotStream = mutableDiskSnapshotStream
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        startTakingDiskSnapshots()
    }

    // MARK: - Private

    private let diskProvider: DiskProviding
    private let mutableDiskSnapshotStream: MutableDiskSnapshotStreaming

    private func startTakingDiskSnapshots() {
        let initialSnapshot: DiskSnapshot? = {
            guard let usage = try? diskProvider.record() else {
                return nil
            }
            return DiskSnapshot(usage: usage, timestamp: .init())
        }()

        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .tryMap { [diskProvider] timestamp -> DiskSnapshot in
                let usage = try diskProvider.record()
                return DiskSnapshot(usage: usage, timestamp: timestamp)
            }
            .replaceError(with: nil)
            .prepend(initialSnapshot)
            .filterNil()
            .removeDuplicates()
            .sink { [mutableDiskSnapshotStream] snapshot in
                mutableDiskSnapshotStream.send(snapshot: snapshot)
            }
            .cancelOnStop(worker: self)
    }

}
