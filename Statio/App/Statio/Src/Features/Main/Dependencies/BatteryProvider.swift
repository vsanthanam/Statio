//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

/// @mockable
protocol BatteryProviding: AnyObject {
    var state: Battery.State { get }
    var level: Battery.Level { get }
}

final class BatteryProvider: BatteryProviding {

    // MARK: - BatteryProviding

    var state: Battery.State {
        Battery.state
    }

    var level: Battery.Level {
        Battery.level
    }

}
