//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol CompassViewControllable: ViewControllable {}

/// @CreateMock
protocol CompassPresentableListener: AnyObject {}

final class CompassViewController: ScopeViewController, CompassPresentable {

    // MARK: - CompassPresentable

    weak var listener: CompassPresentableListener?

}
