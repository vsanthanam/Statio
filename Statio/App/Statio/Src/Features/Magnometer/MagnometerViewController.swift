//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol MagnometerViewControllable: ViewControllable {}

/// @CreateMock
protocol MagnometerPresentableListener: AnyObject {}

final class MagnometerViewController: ScopeViewController, MagnometerPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.magnometer_vc_impression)
    }

    // MARK: - MagnometerPresentable

    weak var listener: MagnometerPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

}
