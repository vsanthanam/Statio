//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol MagnometerViewControllable: ViewControllable {}

/// @CreateMock
protocol MagnometerPresentableListener: AnyObject {}

final class MagnometerViewController: ScopeViewController, MagnometerPresentable {

    // MARK: - API

    weak var listener: MagnometerPresentableListener?

}
