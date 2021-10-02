//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @mockable
protocol CellularViewControllable: ViewControllable {}

/// @mockable
protocol CellularPresentableListener: AnyObject {}

final class CellularViewControler: ScopeViewController, CellularPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.cellular_vc_impression)
    }

    // MARK: - CellularPresentable

    weak var listener: CellularPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
