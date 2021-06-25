//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol SettingsViewControllable: ViewControllable {}

/// @mockable
protocol SettingsPresentableListener: AnyObject {}

final class SettingsViewController: BaseNavigationController, SettingsPresentable, SettingsViewControllable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.settings_vc_impression)
    }

    // MARK: - SettingsPresentable

    weak var listener: SettingsPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
