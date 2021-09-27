//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

protocol ProcessorSnapshotStreaming: AnyObject {
    var snapshots: AnyPublisher<ProcessorSnapshot, Never> { get }
}

protocol MutableProcessorSnapshotStreaming: ProcessorSnapshotStreaming {
    func update(snapshot: ProcessorSnapshot)
}

final class ProcessorSnapshotStream: MutableProcessorSnapshotStreaming {

    // MARK: - Initializers

    init() {}

    // MARK: - ProcessorSnapshotStreaming

    var snapshots: AnyPublisher<ProcessorSnapshot, Never> {
        subject.eraseToAnyPublisher()
    }

    // MARK: - MutableProcessorSnapshotStreaming

    func update(snapshot: ProcessorSnapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = ReplaySubject<ProcessorSnapshot, Never>(bufferSize: 1)

}
