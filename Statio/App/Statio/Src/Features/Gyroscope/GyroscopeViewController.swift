//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol GyroscopeViewControllable: ViewControllable {}

/// @CreateMock
protocol GyroscopePresentableListener: AnyObject {}

final class GyroscopeViewController: ScopeViewController, GyroscopePresentable {

    // MARK: - GyroscopePresentable

    weak var listener: GyroscopePresentableListener?

}
