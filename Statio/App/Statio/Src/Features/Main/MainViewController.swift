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
protocol MainPresentableListener: AnyObject {
    func didSelectTab(withTag tag: Int)
}

final class MainViewController: ScopeViewController, MainPresentable, UITabBarDelegate {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        tabBar = .init()
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        specializedView.backgroundColor = .systemBackground

        tabBar.isTranslucent = false
        tabBar.delegate = self

        specializedView.addSubview(tabBar)

        tabBar.snp.makeConstraints { make in
            make
                .leading
                .bottom
                .trailing
                .equalTo(view.safeAreaLayoutGuide)
        }
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

    func embed(_ viewController: ViewControllable) {
        removeCurrentState()
        addChild(viewController.uiviewController)
        specializedView.addSubview(viewController.uiviewController.view)
        viewController.uiviewController.view.snp.makeConstraints { make in
            make
                .leading
                .top
                .trailing
                .equalToSuperview()
            make
                .bottom
                .equalTo(tabBar.snp.top)
        }
        viewController.uiviewController.didMove(toParent: self)
        currentState = viewController
        setNeedsStatusBarAppearanceUpdate()
    }

    func showTabs(_ models: [MainTabViewModel]) {
        confineTo(viewEvents: [.viewDidLoad], once: false) { [weak self] in
            self?.tabBar.items = models.map(\.tabItem)
        }
    }

    func activateTab(_ id: Int) {
        confineTo(viewEvents: [.viewDidLoad], once: false) { [weak self] in
            guard let self = self else { return }
            guard let item = self.tabBar.items?.first(where: { $0.tag == id }) else {
                loggedAssertionFailure("Cannot activate the tab! No item existst for the tag \(id)", key: "main_view_controller_missing_tab_id")
                return
            }
            self.tabBar.selectedItem = item
        }
    }

    // MARK: - UITabBarDelegate

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        listener?.didSelectTab(withTag: item.tag)
    }

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging
    private let tabBar: UITabBar

    private var currentState: ViewControllable?

    private func removeCurrentState() {
        if let currentState = currentState, children.contains(currentState.uiviewController) {
            currentState.uiviewController.willMove(toParent: nil)
            currentState.uiviewController.view.removeFromSuperview()
            currentState.uiviewController.removeFromParent()
        }
        currentState = nil
    }

}

private extension MainTabViewModel {
    var tabItem: UITabBarItem {
        .init(title: title, image: image, tag: tag)
    }
}
