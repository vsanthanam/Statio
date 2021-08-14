//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import StatioKit

/// @mockable
protocol MemorySnapshotStreaming: AnyObject {
    var memorySnapshot: AnyPublisher<Memory.Snapshot, Never> { get }
}

/// @mockable
protocol MutableMemorySnapshotStreaming: MemorySnapshotStreaming {
    func send(snapshot: Memory.Snapshot)
}

final class MemorySnapshotStream: MutableMemorySnapshotStreaming {

    // MARK: - MemorySnapshotStreaming

    var memorySnapshot: AnyPublisher<Memory.Snapshot, Never> {
        subject
            .filterNil()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableMemorySnapshotStreaming

    func send(snapshot: Memory.Snapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = CurrentValueSubject<Memory.Snapshot?, Never>(nil)

}
