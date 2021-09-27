//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import StatioKit

/// @mockable
protocol MemoryPresentable: MemoryViewControllable {
    var listener: MemoryPresentableListener? { get set }
    func present(snapshot: MemorySnapshot)
}

/// @mockable
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
            .sink { [presenter] snapshot in
                presenter.present(snapshot: snapshot)
            }
            .cancelOnDeactivate(interactor: self)
    }

}
