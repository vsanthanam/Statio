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
protocol RootViewControllable: ViewControllable {}

/// @mockable
protocol RootPresentableListener: AnyObject {}

final class RootViewController: ScopeViewController, RootPresentable, RootViewControllable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.stop(trace: AnalyticsTrace.app_launch)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        mainViewController?.uiviewController.preferredStatusBarStyle ?? .default
    }

    // MARK: - RootPresentable

    weak var listener: RootPresentableListener?

    func showMain(_ viewControllable: ViewControllable) {
        if mainViewController != nil {
            removeMainViewController()
        }
        embedMainViewController(viewControllable)
        setNeedsStatusBarAppearanceUpdate()
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    private var mainViewController: ViewControllable?

    private func embedMainViewController(_ viewController: ViewControllable) {
        loggedAssert(mainViewController == nil, "Unowned Mained View Controller", key: "unowned_main_vc")
        addChild(viewController.uiviewController)
        specializedView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        viewController.uiviewController.didMove(toParent: self)
        mainViewController = viewController
    }

    private func removeMainViewController() {
        loggedAssert(mainViewController != nil, "Missing Mained View Controller", key: "missing_main_vc")
        mainViewController?.uiviewController.willMove(toParent: nil)
        mainViewController?.uiviewController.view.removeFromSuperview()
        mainViewController?.uiviewController.removeFromParent()
        mainViewController = nil
    }
}
