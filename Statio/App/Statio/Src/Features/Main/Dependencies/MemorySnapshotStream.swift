//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import StatioKit

/// @mockable
protocol MemorySnapshotStreaming: AnyObject {
    var snapshots: AnyPublisher<MemorySnapshot, Never> { get }
}

/// @mockable
protocol MutableMemorySnapshotStreaming: MemorySnapshotStreaming {
    func send(snapshot: MemorySnapshot)
}

final class MemorySnapshotStream: MutableMemorySnapshotStreaming {

    // MARK: - MemorySnapshotStreaming

    var snapshots: AnyPublisher<MemorySnapshot, Never> {
        subject
            .filterNil()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableMemorySnapshotStreaming

    func send(snapshot: MemorySnapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = CurrentValueSubject<MemorySnapshot?, Never>(nil)

}
