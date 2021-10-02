//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol CellularViewControllable: ViewControllable {}

/// @mockable
protocol CellularPresentableListener: AnyObject {}

final class CellularViewControler: ScopeViewController, CellularPresentable {

    // MARK: - CellularPresentable

    weak var listener: CellularPresentableListener?

}
