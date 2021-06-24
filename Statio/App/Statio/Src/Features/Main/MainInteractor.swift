//
// Statio
// Varun Santhanam
//

import Foundation
import os.log
import ShortRibs
import UIKit

/// @mockable
protocol MainPresentable: MainViewControllable {
    var listener: MainPresentableListener? { get set }
    func show(_ viewController: ViewControllable)
}

/// @mockable
protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    // MARK: - Initializers

    init(presenter: MainPresentable,
         monitorBuilder: MonitorBuildable) {
        self.monitorBuilder = monitorBuilder
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MainListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        attachMonitor()
    }

    // MARK: - Private

    private let monitorBuilder: MonitorBuildable

    private var monitor: PresentableInteractable?

    private func attachMonitor() {
        let monitor = self.monitor ?? monitorBuilder.build(withListener: self)
        attach(child: monitor)
        presenter.show(monitor.viewControllable)
        self.monitor = monitor
    }

}
