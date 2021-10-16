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
protocol MagnometerListener: AnyObject {}

final class MagnometerInteractor: PresentableInteractor<MagnometerPresentable>, MagnometerInteractable, MagnometerPresentableListener {

    // MARK: - Initializers

    override init(presenter: MagnometerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MagnometerListener?
}
