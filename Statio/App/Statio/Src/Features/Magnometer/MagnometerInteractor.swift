//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol MagnometerPresentable: ViewControllable {
    var listener: MagnometerPresentableListener? { get set }
}

/// @CreateMock
protocol MagnometerListener: AnyObject {
    func magnometerDidClose()
}

final class MagnometerInteractor: PresentableInteractor<MagnometerPresentable>, MagnometerInteractable, MagnometerPresentableListener {

    // MARK: - Initializers

    override init(presenter: MagnometerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MagnometerListener?

    // MARK: - MagnometerPresentableListener

    func didTapBack() {
        listener?.magnometerDidClose()
    }
}
