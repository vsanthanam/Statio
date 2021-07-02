//
// Statio
// Varun Santhanam
//

import SnapKit
import UIKit

open class ParentScopeNavigationController: ScopeViewController {

    // MARK: - API

    public enum Direction {
        case push
        case pop
    }

    public var navigationBar: UINavigationBar {
        nav.navigationBar
    }

    public var activeViewController: ViewControllable? {
        nav.viewControllers.first as? ViewControllable
    }

    public func setActiveViewController(_ viewController: ViewControllable) {
        nav.viewControllers = [viewController.uiviewController]
    }

    public func pushActiveViewController(_ viewController: ViewControllable, completionHandler: (() -> Void)? = nil) {
        embedActiveChild(viewController, with: .push, animated: true, completionHandler: completionHandler)
    }

    public func popActiveViewController(_ viewController: ViewControllable, completionHandler: (() -> Void)? = nil) {
        embedActiveChild(viewController, with: .pop, animated: true, completionHandler: completionHandler)
    }

    // MARK: - UIViewController

    override open func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
    }

    private func embedActiveChild(_ viewController: ViewControllable, with direction: Direction, animated: Bool, completionHandler: (() -> Void)?) {
        guard !nav.viewControllers.contains(viewController.uiviewController) else {
            return
        }
        switch direction {
        case .pop:
            nav.setViewControllers([viewController.uiviewController] + nav.viewControllers, animated: false)
            nav.popToViewController(viewController.uiviewController, animated: animated) {
                completionHandler?()
            }
        case .push:
            nav.pushViewController(viewController: viewController.uiviewController, animated: animated) { [weak nav] in
                nav?.viewControllers = [viewController.uiviewController]
                completionHandler?()
            }
        }
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
