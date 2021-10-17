//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @CreateMock
protocol MapViewControllable: ViewControllable {}

/// @CreateMock
protocol MapPresentableListener: AnyObject {}

final class MapViewController: ScopeViewController, MapPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.map_vc_impression)
    }

    // MARK: - MapPresentable

    weak var listener: MapPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
