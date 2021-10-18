//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @CreateMock
protocol AltimeterViewControllable: ViewControllable {}

/// @CreateMock
protocol AltimeterPresentableListener: AnyObject {}

final class AltimeterViewController: ScopeViewController, AltimeterPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.altimeter_vc_impression)
    }

    // MARK: - AltimeterPresentable

    weak var listener: AltimeterPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
