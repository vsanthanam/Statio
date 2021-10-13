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

/// @CreateMock
protocol SettingsListener: AnyObject {}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {

    // MARK: - Initializers

    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: SettingsListener?
}
