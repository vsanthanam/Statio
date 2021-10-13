//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol SettingsViewControllable: ViewControllable {}

/// @CreateMock
protocol SettingsPresentableListener: AnyObject {}

final class SettingsViewController: ParentScopeNavigationController, SettingsPresentable, SettingsViewControllable {

    // MARK: - Initializers

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
