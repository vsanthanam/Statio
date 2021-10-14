//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol AccelerometerPresentable: AccelerometerViewControllable {
    var listener: AccelerometerPresentableListener? { get set }
}

/// @CreateMock
protocol AccelerometerListener: AnyObject {
    func accelerometerDidClose()
}

final class AccelerometerInteractor: PresentableInteractor<AccelerometerPresentable>, AccelerometerInteractable, AccelerometerPresentableListener {

    // MARK: - Initializers

    override init(presenter: AccelerometerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: AccelerometerListener?

    // MARK: - AccelerometerPresentableListener

    func didTapBack() {
        listener?.accelerometerDidClose()
    }

}
