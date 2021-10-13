//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

/// @CreateMock
protocol DiskSnapshotStreaming: AnyObject {
    var snapshots: AnyPublisher<DiskSnapshot, Never> { get }
}

/// @CreateMock
protocol MutableDiskSnapshotStreaming: DiskSnapshotStreaming {
    func send(snapshot: DiskSnapshot)
}

final class DiskSnapshotStream: MutableDiskSnapshotStreaming {

    // MARK: - DiskSnapshotStreaming

    var snapshots: AnyPublisher<DiskSnapshot, Never> {
        subject
            .filterNil()
            .eraseToAnyPublisher()
    }

    // MARK: - MutableDiskSnapshotStreaming

    func send(snapshot: DiskSnapshot) {
        subject.send(snapshot)
    }

    // MARK: - Private

    private let subject = CurrentValueSubject<DiskSnapshot?, Never>(nil)

}
