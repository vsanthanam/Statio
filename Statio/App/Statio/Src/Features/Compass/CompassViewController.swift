//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @CreateMock
protocol CompassViewControllable: ViewControllable {}

/// @CreateMock
protocol CompassPresentableListener: AnyObject {}

final class CompassViewController: ScopeViewController, CompassPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.compass_vc_impression)
    }

    // MARK: - CompassPresentable

    weak var listener: CompassPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
