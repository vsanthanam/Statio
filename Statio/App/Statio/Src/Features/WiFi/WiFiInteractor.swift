//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol WiFiPresentable: WiFiViewControllable {
    var listener: WiFiPresentableListener? { get set }
}

/// @CreateMock
protocol WiFiListener: AnyObject {
    func wifiDidClose()
}

final class WiFiInteractor: PresentableInteractor<WiFiPresentable>, WiFiInteractable, WiFiPresentableListener {

    // MARK: - Initializers

    override init(presenter: WiFiPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: WiFiListener?

    // MARK: - WiFiPresentableListener

    func didTapBack() {
        listener?.wifiDidClose()
    }

}
