//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol AltimeterViewControllable: ViewControllable {}

/// @CreateMock
protocol AltimeterPresentableListener: AnyObject {}

final class AltimeterViewController: ScopeViewController, AltimeterPresentable {

    // MARK: - AltimeterPresentablw

    weak var listener: AltimeterPresentableListener?

}
