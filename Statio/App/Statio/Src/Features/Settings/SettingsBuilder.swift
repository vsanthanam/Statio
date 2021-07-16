//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol SettingsDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

class SettingsComponent: Component<SettingsDependency> {}

/// @mockable
protocol SettingsInteractable: PresentableInteractable {}

typealias SettingsDynamicBuildDependency = (
    SettingsListener
)

/// @mockable
protocol SettingsBuildable: AnyObject {
    func build(withListener listener: SettingsListener) -> PresentableInteractable
}

final class SettingsBuilder: ComponentizedBuilder<SettingsComponent, PresentableInteractable, SettingsDynamicBuildDependency, Void>, SettingsBuildable {

    // MARK: - ComponentizedBuilder

    override final func build(with component: SettingsComponent, _ dynamicBuildDependency: SettingsDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = SettingsViewController(analyticsManager: component.analyticsManager)
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener
        return interactor
    }

    // MARK: - SettingsBuildable

    func build(withListener listener: SettingsListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
