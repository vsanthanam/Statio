//
// Aro
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

    func show(_ viewController: ViewControllable) {
        guard viewController !== currentState else {
            return
        }

        currentState?.uiviewController.willMove(toParent: nil)
        addChild(viewController.uiviewController)

        viewController.uiviewController.view.alpha = 0.0
        specializedView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }

        UIView.animate(withDuration: 0.4,
                       animations: { [currentState] in
                           currentState?.uiviewController.view.alpha = 0.0
                           viewController.uiviewController.view.alpha = 1.0
                       }, completion: { [weak self] _ in
                           self?.currentState?.uiviewController.removeFromParent()
                           self?.currentState?.uiviewController.view.removeFromSuperview()
                           viewController.uiviewController.didMove(toParent: self)
                           self?.currentState = viewController
                           self?.setNeedsStatusBarAppearanceUpdate()
                       })
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    private var currentState: ViewControllable?

}
