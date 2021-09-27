//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol ProcessorViewControllable: ViewControllable {}

/// @mockable
protocol ProcessorPresentableListener: AnyObject {}

final class ProcessorViewController: ScopeViewController, ProcessorPresentable {

    // MARK: - ProcessorPresentable

    weak var listener: ProcessorPresentableListener?

}
