//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol AltimeterPresentable: AltimeterViewControllable {
    var listener: AltimeterPresentableListener? { get set }
}

/// @CreateMock
protocol AltimeterListener: AnyObject {}

final class AltimeterInteractor: PresentableInteractor<AltimeterPresentable>, AltimeterInteractable, AltimeterPresentableListener {

    // MARK: - Initializers

    override init(presenter: AltimeterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: AltimeterListener?

}
