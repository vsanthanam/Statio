//
// Statio
// Varun Santhanam
//

import Foundation
import MonitorKit
import ShortRibs

/// @CreateMock
protocol MemoryPresentable: MemoryViewControllable {
    var listener: MemoryPresentableListener? { get set }
    func present(snapshot: MemorySnapshot)
}

/// @CreateMock
protocol MemoryListener: AnyObject {
    func memoryDidClose()
}

final class MemoryInteractor: PresentableInteractor<MemoryPresentable>, MemoryInteractable, MemoryPresentableListener {

    // MARK: - Initializers

    init(presenter: MemoryPresentable,
         memorySnapshotStream: MemorySnapshotStreaming) {
        self.memorySnapshotStream = memorySnapshotStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingMemorySnapshots()
    }

    // MARK: - API

    weak var listener: MemoryListener?

    // MARK: - MemoryPresentableListener

    func didTapBack() {
        listener?.memoryDidClose()
    }

    // MARK: - Private

    private let memorySnapshotStream: MemorySnapshotStreaming

    private func startObservingMemorySnapshots() {
        memorySnapshotStream.snapshots
            .removeDuplicates { lhs, rhs in
                lhs.usage == rhs.usage
            }
            .sink(receiveValue: presenter.present)
            .cancelOnDeactivate(interactor: self)
    }

}
