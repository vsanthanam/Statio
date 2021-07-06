//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol DeviceIdentityPresentable: DeviceIdentityViewControllable {
    var listener: DeviceIdentityPresentableListener? { get set }
}

/// @mockable
protocol DeviceIdentityListener: AnyObject {}

final class DeviceIdentityInteractor: PresentableInteractor<DeviceIdentityPresentable>, DeviceIdentityInteractable, DeviceIdentityPresentableListener {

    // MARK: - Initializers

    override init(presenter: DeviceIdentityPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: DeviceIdentityListener?
}
