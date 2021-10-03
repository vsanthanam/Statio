//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol WiFiPresentable: WiFiViewControllable {
    var listener: WiFiPresentableListener? { get set }
}

/// @mockable
protocol WiFiListener: AnyObject {}

final class WiFiInteractor: PresentableInteractor<WiFiPresentable>, WiFiInteractable, WiFiPresentableListener {

    // MARK: - Initializers

    override init(presenter: WiFiPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: WiFiListener?

}
