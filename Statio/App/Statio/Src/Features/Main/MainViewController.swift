//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import SnapKit
import UIKit

/// @mockable
protocol MainViewControllable: ViewControllable {}

/// @mockable
protocol MainPresentableListener: AnyObject {}

final class MainViewController: ScopeViewController, MainPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init(ScopeView.init)
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.main_vc_impression)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        currentState?.uiviewController.preferredStatusBarStyle ?? .default
    }

    // MARK: - MainPresentable

    weak var listener: MainPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    private var currentState: ViewControllable?

}
