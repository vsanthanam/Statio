//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol DiskPresentable: DiskViewControllable {
    var listener: DiskPresentableListener? { get set }
}

/// @mockable
protocol DiskListener: AnyObject {
    func diskDidClose()
}

final class DiskInteractor: PresentableInteractor<DiskPresentable>, DiskInteractable, DiskPresentableListener {

    // MARK: - Initializers

    override init(presenter: DiskPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: DiskListener?

    // MARK: - DiskPresentableListener

    func didTapBack() {
        listener?.diskDidClose()
    }

}
