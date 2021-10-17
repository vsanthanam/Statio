//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @CreateMock
protocol MapViewControllable: ViewControllable {}

/// @CreateMock
protocol MapPresentableListener: AnyObject {}

final class MapViewController: ScopeViewController, MapPresentable {

    // MARK: - MapPresentable

    weak var listener: MapPresentableListener?

}
