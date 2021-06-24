//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MonitorPresentable: MonitorViewControllable {
    var listener: MonitorPresentableListener? { get set }
}

/// @mockable
protocol MonitorListener: AnyObject {}

final class MonitorInteractor: PresentableInteractor<MonitorPresentable>, MonitorInteractable, MonitorPresentableListener {

    // MARK: - Initializers

    override init(presenter: MonitorPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MonitorListener?

}
