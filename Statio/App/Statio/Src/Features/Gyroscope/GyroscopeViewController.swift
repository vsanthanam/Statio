//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @CreateMock
protocol GyroscopeViewControllable: ViewControllable {}

/// @CreateMock
protocol GyroscopePresentableListener: AnyObject {}

final class GyroscopeViewController: ScopeViewController, GyroscopePresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.gyroscope_vc_impression)
    }

    // MARK: - GyroscopePresentable

    weak var listener: GyroscopePresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
