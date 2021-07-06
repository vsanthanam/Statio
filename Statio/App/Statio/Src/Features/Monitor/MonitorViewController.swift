//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol MonitorViewControllable: ViewControllable {}

/// @mockable
protocol MonitorPresentableListener: AnyObject {}

final class MonitorViewController: ParentScopeNavigationController, MonitorPresentable, MonitorViewControllable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.monitor_vc_impression)
    }

    // MARK: - MonitorPresentable

    weak var listener: MonitorPresentableListener?

    func showList(_ monitorList: MonitorListViewControllable) {
        if activeViewController == nil {
            setActiveViewController(monitorList)
        } else {
            popActiveViewController(monitorList)
        }
    }

    func showMonitor(_ viewController: ViewControllable) {
        if activeViewController == nil {
            setActiveViewController(viewController)
        } else {
            pushActiveViewController(viewController)
        }
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
