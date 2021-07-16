//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

/// @mockable
protocol MemorySnapshotStreaming: AnyObject {
    var memorySnapshot: AnyPublisher<MemoryMonitor.Snapshot, Never> { get }
}

/// @mockable
protocol MutableMemorySnapshotStreaming: MemorySnapshotStreaming {
    func send(snapshot: MemoryMonitor.Snapshot)
}

final class MemorySnapshotStream: MutableMemorySnapshotStreaming {

    // MARK: - MemorySnapshotStreaming

    var memorySnapshot: AnyPublisher<MemoryMonitor.Snapshot, Never> {
        subject
            .filterNil()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableMemorySnapshotStreaming

    func send(snapshot: MemoryMonitor.Snapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = CurrentValueSubject<MemoryMonitor.Snapshot?, Never>(nil)

}
