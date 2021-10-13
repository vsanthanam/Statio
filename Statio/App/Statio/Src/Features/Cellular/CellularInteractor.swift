//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol CellularPresentable: CellularViewControllable {
    var listener: CellularPresentableListener? { get set }
}

/// @CreateMock
protocol CellularListener: AnyObject {
    func cellularDidClose()
}

final class CellularInteractor: PresentableInteractor<CellularPresentable>, CellularInteractable, CellularPresentableListener {

    // MARK: - Initializers

    override init(presenter: CellularPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: CellularListener?

    // MARK: - CellularPresentableListener

    func didTapBack() {
        listener?.cellularDidClose()
    }
}
