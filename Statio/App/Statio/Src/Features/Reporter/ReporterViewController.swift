//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol ReporterViewControllable: ViewControllable {}

/// @mockable
protocol ReporterPresentableListener: AnyObject {}

final class ReporterViewController: ParentScopeNavigationController, ReporterPresentable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }

    // MARK: - ReporterPresentable

    weak var listener: ReporterPresentableListener?

}
