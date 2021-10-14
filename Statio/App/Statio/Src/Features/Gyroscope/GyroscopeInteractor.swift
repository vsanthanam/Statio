//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol GyroscopePresentable: AnyObject {
    var listener: GyroscopePresentableListener? { get set }
}

/// @CreateMock
protocol GyroscopeListener: AnyObject {
    func gyroscopeDidClose()
}

final class GyroscopeInteractor: PresentableInteractor<GyroscopePresentable>, GyroscopeInteractable, GyroscopePresentableListener {

    // MARK: - Initializers

    override init(presenter: GyroscopePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: GyroscopeListener?

    // MARK: - GyroscopePresentableListener

    func didTapBack() {
        listener?.gyroscopeDidClose()
    }

}
