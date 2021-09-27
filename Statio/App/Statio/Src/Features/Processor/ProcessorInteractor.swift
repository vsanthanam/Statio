//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol ProcessorPresentable: ProcessorViewControllable {
    var listener: ProcessorPresentableListener? { get set }
}

/// @mockable
protocol ProcessorListener: AnyObject {
    func processorDidClose()
}

final class ProcessorInteractor: PresentableInteractor<ProcessorPresentable>, ProcessorInteractable, ProcessorPresentableListener {

    // MARK: - Initializer

    override init(presenter: ProcessorPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: ProcessorListener?

    // MARK: - ProcessorPresentableListener

    func didTapBack() {
        listener?.processorDidClose()
    }

}
