//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol CompassPresentable: CompassViewControllable {
    var listener: CompassPresentableListener? { get set }
}

/// @CreateMock
protocol CompassListener: AnyObject {
    func compassDidClose()
}

final class CompassInteractor: PresentableInteractor<CompassPresentable>, CompassInteractable, CompassPresentableListener {

    // MARK: - Initializers

    override init(presenter: CompassPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: CompassListener?

    // MARK: - CompassPresentableListener

    func didTapBack() {
        listener?.compassDidClose()
    }
}
