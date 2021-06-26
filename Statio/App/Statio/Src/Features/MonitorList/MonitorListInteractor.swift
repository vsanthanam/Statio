//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MonitorListPresentable: MonitorListViewControllable {
    var listener: MonitorListPresentableListener? { get set }
    func applyIdentifiers(_ identifiers: [MonitorIdentifier], categories: [MonitorCategoryIdentifier])
}

/// @mockable
protocol MonitorListListener: AnyObject {
    func monitorListDidSelect(identifier: MonitorIdentifier)
}

final class MonitorListInteractor: PresentableInteractor<MonitorListPresentable>, MonitorListInteractable, MonitorListPresentableListener {

    // MARK: - Initializers

    override init(presenter: MonitorListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MonitorListListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        configureMonitors()
    }

    // MARK: - MonitorListInteractable

    var viewController: MonitorListViewControllable {
        presenter
    }

    // MARK: - MonitorListPresentableListener

    func didSelectMonitor(withIdentifier identifier: MonitorIdentifier) {
        listener?.monitorListDidSelect(identifier: identifier)
    }

    // MARK: - Private

    func configureMonitors() {
        presenter.applyIdentifiers(MonitorIdentifier.allCases, categories: MonitorCategoryIdentifier.allCases)
    }
}
