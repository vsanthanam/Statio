//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MemoryPresentable: MemoryViewControllable {
    var listener: MemoryPresentableListener? { get set }
}

/// @mockable
protocol MemoryListener: AnyObject {}

final class MemoryInteractor: PresentableInteractor<MemoryPresentable>, MemoryInteractable, MemoryPresentableListener {

    // MARK: - Initializers

    override init(presenter: MemoryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MemoryListener?

}
