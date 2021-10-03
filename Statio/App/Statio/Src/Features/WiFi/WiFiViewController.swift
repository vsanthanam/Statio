//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol WiFiViewControllable: ViewControllable {}

/// @mockable
protocol WiFiPresentableListener: AnyObject {}

final class WiFiViewController: ScopeViewController, WiFiPresentable {

    // MARK: - WiFiPresentable

    weak var listener: WiFiPresentableListener?

}
