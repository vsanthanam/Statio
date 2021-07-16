//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol MemoryViewControllable: ViewControllable {}

/// @mockable
protocol MemoryPresentableListener: AnyObject {}

final class MemoryViewController: ScopeViewController, MemoryPresentable, MemoryViewControllable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.memory_vc_impression)
    }

    // MARK: - MemoryPresentable

    weak var listener: MemoryPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
}
