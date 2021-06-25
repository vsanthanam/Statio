//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol SettingsPresentable: SettingsViewControllable {
    var listener: SettingsPresentableListener? { get set }
}

/// @mockable
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
