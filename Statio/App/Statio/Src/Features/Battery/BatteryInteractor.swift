//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol BatteryPresentable: BatteryViewControllable {
    var listener: BatteryPresentableListener? { get set }
}

/// @mockable
protocol BatteryListener: AnyObject {
    func batteryDidClose()
}

final class BatteryInteractor: PresentableInteractor<BatteryPresentable>, BatteryInteractable, BatteryPresentableListener {

    // MARK: - Initializers

    override init(presenter: BatteryPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: BatteryListener?

    // MARK: - BatteryPresentableListener

    func didTapBack() {
        listener?.batteryDidClose()
    }
}
