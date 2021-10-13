//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @CreateMock
protocol ProcessorSnapshotStreaming: AnyObject {
    var snapshots: AnyPublisher<ProcessorSnapshot, Never> { get }
}

/// @CreateMock
protocol MutableProcessorSnapshotStreaming: ProcessorSnapshotStreaming {
    func send(snapshot: ProcessorSnapshot)
}

final class ProcessorSnapshotStream: MutableProcessorSnapshotStreaming {

    // MARK: - Initializers

    init() {}

    // MARK: - ProcessorSnapshotStreaming

    var snapshots: AnyPublisher<ProcessorSnapshot, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: - MutableProcessorSnapshotStreaming

    func send(snapshot: ProcessorSnapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = ReplaySubject<ProcessorSnapshot, Never>(bufferSize: 1)

}
