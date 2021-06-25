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

final class MonitorViewController: BaseNavigationController, MonitorPresentable, MonitorViewControllable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.monitor_vc_impression)
    }

    // MARK: - MonitorPresentable

    weak var listener: MonitorPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
