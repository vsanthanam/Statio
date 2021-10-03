//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol ProcessorMonitorWorking: Working {}

final class ProcessorMonitorWorker: Worker, ProcessorMonitorWorking {

    // MARK: - Initializers

    init(processorProvider: ProcessorProviding,
         mutableProcessorSnapshotStream: MutableProcessorSnapshotStreaming) {
        self.processorProvider = processorProvider
        self.mutableProcessorSnapshotStream = mutableProcessorSnapshotStream
        super.init()
    }

    // MARK: - Worker

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        startTakingProcessorSnapshots()
    }

    // MARK: - Private

    private let processorProvider: ProcessorProviding
    private let mutableProcessorSnapshotStream: MutableProcessorSnapshotStreaming

    private func startTakingProcessorSnapshots() {
        let initialSnapshot: ProcessorSnapshot? = {
            guard let usage = try? processorProvider.record() else {
                return nil
            }
            return ProcessorSnapshot(usage: usage, timestamp: .init())
        }()

        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .tryMap { [processorProvider] timestamp -> ProcessorSnapshot in
                let usage = try processorProvider.record()
                return ProcessorSnapshot(usage: usage, timestamp: timestamp)
            }
            .replaceError(with: nil)
            .prepend(initialSnapshot)
            .filterNil()
            .removeDuplicates()
            .sink { [mutableProcessorSnapshotStream] snapshot in
                mutableProcessorSnapshotStream.send(snapshot: snapshot)
            }
            .cancelOnStop(worker: self)
    }
}
