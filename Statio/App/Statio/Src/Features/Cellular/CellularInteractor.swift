//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol CellularPresentable: CellularViewControllable {
    var listener: CellularPresentableListener? { get set }
}

/// @mockable
protocol CellularListener: AnyObject {}

final class CellularInteractor: PresentableInteractor<CellularPresentable>, CellularInteractable, CellularPresentableListener {

    // MARK: - Initializers

    override init(presenter: CellularPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: CellularListener?
}
