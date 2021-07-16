//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MemoryPresentable: MemoryViewControllable {
    var listener: MemoryPresentableListener? { get set }
    func present(snapshot: MemoryMonitor.Snapshot)
}

/// @mockable
protocol MemoryListener: AnyObject {}

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
