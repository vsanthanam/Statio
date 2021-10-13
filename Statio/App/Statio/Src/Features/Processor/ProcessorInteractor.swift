//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol ProcessorPresentable: ProcessorViewControllable {
    var listener: ProcessorPresentableListener? { get set }
    func present(snapshot: ProcessorSnapshot)
}

/// @CreateMock
protocol ProcessorListener: AnyObject {
    func processorDidClose()
}

final class ProcessorInteractor: PresentableInteractor<ProcessorPresentable>, ProcessorInteractable, ProcessorPresentableListener {

    // MARK: - Initializer

    init(presenter: ProcessorPresentable,
         processorSnapshotStream: ProcessorSnapshotStreaming) {
        self.processorSnapshotStream = processorSnapshotStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: ProcessorListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingProcessorSnapshots()
    }

    // MARK: - ProcessorPresentableListener

    func didTapBack() {
        listener?.processorDidClose()
    }

    // MARK: - Private

    private let processorSnapshotStream: ProcessorSnapshotStreaming

    private func startObservingProcessorSnapshots() {
        processorSnapshotStream.snapshots
            .removeDuplicates { lhs, rhs in
                lhs.usage == rhs.usage
            }
            .sink(receiveValue: presenter.present)
            .cancelOnDeactivate(interactor: self)
    }

}
