//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol SettingsPresentable: SettingsViewControllable {
    var listener: SettingsPresentableListener? { get set }
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {

    // MARK: - Initializers

    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

}
