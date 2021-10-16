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

/// @CreateMock
protocol SettingsInteractable: PresentableInteractable {}

/// @CreateMock
protocol SettingsBuildable: AnyObject {
    func build() -> PresentableInteractable
}

final class SettingsBuilder: SimpleComponentizedBuilder<SettingsComponent, PresentableInteractable>, SettingsBuildable {

    // MARK: - SimpleComponentizedBuilder

    override final func build(with component: SettingsComponent) -> PresentableInteractable {
        let viewController = SettingsViewController(analyticsManager: component.analyticsManager)
        let interactor = SettingsInteractor(presenter: viewController)
        return interactor
    }

}
