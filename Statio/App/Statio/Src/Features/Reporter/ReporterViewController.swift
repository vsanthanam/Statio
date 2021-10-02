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

final class ReporterViewController: ScopeViewController, ReporterPresentable {

    // MARK: - ReporterPresentable

    weak var listener: ReporterPresentableListener?

}
