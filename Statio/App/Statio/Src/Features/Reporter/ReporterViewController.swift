//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol ReporterViewControllable: ViewControllable {}

/// @mockable
protocol ReporterPresentableListener: AnyObject {}

final class ReporterViewController: ParentScopeNavigationController, ReporterPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.reporter_vc_impression)
    }

    // MARK: - ReporterPresentable

    weak var listener: ReporterPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
