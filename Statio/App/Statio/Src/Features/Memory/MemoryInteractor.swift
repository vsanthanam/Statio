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
    func present(snapshot: Memory.Snapshot)
}

/// @mockable
protocol MemoryListener: AnyObject {
    func memoryDidClose()
}

final class MemoryInteractor: PresentableInteractor<MemoryPresentable>, MemoryInteractable, MemoryPresentableListener {

    // MARK: - Initializers

    init(presenter: MemoryPresentable,
         memoryMonitor: MemoryMonitoring,
         memorySnapshotStream: MemorySnapshotStreaming) {
        self.memoryMonitor = memoryMonitor
        self.memorySnapshotStream = memorySnapshotStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingMemorySnapshots()
        memoryMonitor.start(on: self)
    }

    // MARK: - API

    weak var listener: MemoryListener?

    // MARK: - MemoryPresentableListener

    func didTapBack() {
        listener?.memoryDidClose()
    }

    // MARK: - Private

    private let memoryMonitor: MemoryMonitoring
    private let memorySnapshotStream: MemorySnapshotStreaming

    private func startObservingMemorySnapshots() {
        memorySnapshotStream.memorySnapshot
            .sink { [presenter] snapshot in
                presenter.present(snapshot: snapshot)
            }
            .cancelOnDeactivate(interactor: self)
    }

}
