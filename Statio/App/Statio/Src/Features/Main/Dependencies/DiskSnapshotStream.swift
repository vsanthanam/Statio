//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

/// @mockable
protocol DiskSnapshotStreaming: AnyObject {
    var snapshot: AnyPublisher<DiskSnapshot, Never> { get }
}

/// @mockable
protocol MutableDiskSnapshotStreaming: DiskSnapshotStreaming {
    func send(snapshot: DiskSnapshot)
}

final class DiskSnapshotStream: MutableDiskSnapshotStreaming {

    // MARK: - DiskSnapshotStreaming

    var snapshot: AnyPublisher<DiskSnapshot, Never> {
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
