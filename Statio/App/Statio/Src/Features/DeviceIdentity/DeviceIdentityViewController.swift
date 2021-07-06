//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol DeviceIdentityViewControllable: ViewControllable {}

/// @mockable
protocol DeviceIdentityPresentableListener: AnyObject {}

final class DeviceIdentityViewController: ScopeViewController, DeviceIdentityPresentable, DeviceIdentityViewControllable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        specializedView.backgroundColor = .systemBackground
        title = "Identity"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.device_identity_vc_impression)
    }

    // MARK: - DeviceIdentityPresentable

    weak var listener: DeviceIdentityPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
