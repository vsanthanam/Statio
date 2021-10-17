//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs
import UIKit

typealias RootDynamicComponentDependency = (AnalyticsManaging)

final class RootComponent: BootstrapComponent, ShortRibs.RootComponent {

    // MARK: - Initializers

    init(dynamicDependency: RootDynamicComponentDependency) {
        self.dynamicDependency = dynamicDependency
    }

    // MARK: - Published Dependencies

    var analyticsManager: AnalyticsManaging {
        dynamicDependency
    }

    // MARK: - Children

    var mainBuilder: MainBuildable {
        MainBuilder { MainComponent(parent: self) }
    }

    // MARK: - Private

    private let dynamicDependency: RootDynamicComponentDependency
}

/// @CreateMock
protocol RootInteractable: PresentableInteractable {
    func openURL(_ url: URL)
}

typealias RootDynamicBuildDependency = (
    UIWindow
)

/// @CreateMock
protocol RootBuildable: AnyObject {
    func build(onWindow window: UIWindow,
               analyticsManager: AnalyticsManaging) -> RootInteractable
}

final class RootBuilder: ComponentizedRootBuilder<RootComponent, RootInteractable, RootDynamicBuildDependency, RootDynamicComponentDependency>, RootBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: RootComponent,
                              _ dynamicBuildDependency: RootDynamicBuildDependency) -> RootInteractable {
        let window = dynamicBuildDependency
        let viewController = RootViewController(analyticsManager: component.analyticsManager)
        let interactor = RootInteractor(presenter: viewController,
                                        analyticsManager: component.analyticsManager,
                                        mainBuilder: component.mainBuilder)
        window.rootViewController = viewController
        return interactor
    }

    // MARK: - RootBuildable

    func build(onWindow window: UIWindow,
               analyticsManager: AnalyticsManaging) -> RootInteractable {
        build(withDynamicBuildDependency: window,
              dynamicComponentDependency: analyticsManager)
    }

}
