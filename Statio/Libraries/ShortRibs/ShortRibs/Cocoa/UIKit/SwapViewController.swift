//
// Statio
// Varun Santhanam
//

import SnapKit
import UIKit

open class ParentNavigationController: ScopeViewController {

    // MARK: - UIViewController

    override open func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    public enum Direction {
        case push
        case pop
    }

    // MARK: - API

    public var parentBar: UINavigationBar {
        nav.navigationBar
    }

    public func setBarColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 10 // This is added to the default margin
        appearance.backgroundColor = color
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
    }

    open func embedActiveChild(_ viewController: ViewControllable, with direction: Direction) {
        guard !nav.viewControllers.contains(viewController.uiviewController) else {
            return
        }
        switch direction {
        case .pop:
            nav.setViewControllers([viewController.uiviewController] + nav.viewControllers, animated: false)
            nav.popToViewController(viewController.uiviewController, animated: true)
        case .push:
            nav.pushViewController(viewController: viewController.uiviewController, animated: true) { [weak nav] in
                nav?.viewControllers = [viewController.uiviewController]
            }
        }
    }

    // MARK: - Private

    private let nav = UINavigationController()

    private func setUp() {
        addChild(nav)
        view.addSubview(nav.view)
        nav.view.snp.makeConstraints { make in
            make
                .edges
                .equalToSuperview()
        }
        nav.didMove(toParent: self)
        setBarColor(.white)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.prefersLargeTitles = true
    }
}

public extension UINavigationController {

    func pushViewController(viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }

    @discardableResult
    func popToViewController(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)?) -> [UIViewController]? {
        let vcs = popToViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return vcs
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
        return vcs
    }

    func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            defer {
                completion?()
            }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }

}
