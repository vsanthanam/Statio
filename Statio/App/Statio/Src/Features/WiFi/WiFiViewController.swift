//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol WiFiViewControllable: ViewControllable {}

/// @mockable
protocol WiFiPresentableListener: AnyObject {}

final class WiFiViewController: ScopeViewController, WiFiPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.wifi_vc_impression)
    }

    // MARK: - WiFiPresentable

    weak var listener: WiFiPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
