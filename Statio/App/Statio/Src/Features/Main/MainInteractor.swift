//
// Aro
// Varun Santhanam
//

import Foundation
import os.log
import ShortRibs
import UIKit

/// @mockable
protocol MainPresentable: MainViewControllable {
    var listener: MainPresentableListener? { get set }
    func show(_ viewController: ViewControllable)
}

/// @mockable
protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    // MARK: - Initializers

    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MainListener?

}
