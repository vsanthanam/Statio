//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol MonitorPresentable: MonitorViewControllable {
    var listener: MonitorPresentableListener? { get set }
    func showList(_ monitorList: MonitorListViewControllable)
}

/// @mockable
protocol MonitorListener: AnyObject {}

final class MonitorInteractor: PresentableInteractor<MonitorPresentable>, MonitorInteractable, MonitorPresentableListener {

    // MARK: - Initializers

    init(presenter: MonitorPresentable,
         monitorListBuilder: MonitorListBuildable) {
        self.monitorListBuilder = monitorListBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MonitorListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        let monitorList = monitorListBuilder.build(withListener: self)
        attach(child: monitorList)
        presenter.showList(monitorList.viewController)
    }

    // MARK: - MonitorListListener

    func monitorListDidSelect(identifier: MonitorIdentifier) {}

    // MARK: - Private

    private let monitorListBuilder: MonitorListBuildable
}
