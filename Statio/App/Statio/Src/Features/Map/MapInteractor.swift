//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol MapPresentable: MapViewControllable {
    var listener: MapPresentableListener? { get set }
}

/// @CreateMock
protocol MapListener: AnyObject {
    func mapDidClose()
}

final class MapInteractor: PresentableInteractor<MapPresentable>, MapInteractable, MapPresentableListener {

    // MARK: - Initializers

    override init(presenter: MapPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MapListener?

    // MARK: - MapPresentableListener

    func didTapBack() {
        listener?.mapDidClose()
    }

}
