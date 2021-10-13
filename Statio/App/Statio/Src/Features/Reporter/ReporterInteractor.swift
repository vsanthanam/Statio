//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol ReporterPresentable: ReporterViewControllable {
    var listener: ReporterPresentableListener? { get set }
}

/// @CreateMock
protocol ReporterListener: AnyObject {}

final class ReporterInteractor: PresentableInteractor<ReporterPresentable>, ReporterInteractable, ReporterPresentableListener {

    // MARK: - Initializers

    override init(presenter: ReporterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: ReporterListener?

}
