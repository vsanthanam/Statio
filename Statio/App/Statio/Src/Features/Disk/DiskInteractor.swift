//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol DiskPresentable: DiskViewControllable {
    var listener: DiskPresentableListener? { get set }
    func present(snapshot: DiskSnapshot)
}

/// @mockable
protocol DiskListener: AnyObject {
    func diskDidClose()
}

final class DiskInteractor: PresentableInteractor<DiskPresentable>, DiskInteractable, DiskPresentableListener {

    // MARK: - Initializers

    init(presenter: DiskPresentable,
         diskSnapshotStream: DiskSnapshotStreaming) {
        self.diskSnapshotStream = diskSnapshotStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: DiskListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingDiskSnapshot()

    }

    // MARK: - DiskPresentableListener

    func didTapBack() {
        listener?.diskDidClose()
    }

    // MARK: - Private

    private let diskSnapshotStream: DiskSnapshotStreaming

    private func startObservingDiskSnapshot() {
//        diskSnapshotStream.snapshot
//            .removeDuplicates { lhs, rhs in
//                lhs.usage == rhs.usage
//            }
//            .sink { [presenter] snapshot in
//                presenter.present(snapshot: snapshot)
//            }
//            .cancelOnDeactivate(interactor: self)
    }

}
