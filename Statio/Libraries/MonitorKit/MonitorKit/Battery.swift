//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

public enum Battery {

    public enum State {
        case unknown
        case discharging
        case charging
        case full
    }

    public typealias Level = Float

    public static var state: State {
        UIDevice.current.batteryState.asState
    }

    public static var level: Level {
        UIDevice.current.batteryLevel
    }
}

private extension UIDevice.BatteryState {
    var asState: Battery.State {
        switch self {
        case .unknown:
            return .unknown
        case .charging:
            return .charging
        case .unplugged:
            return .discharging
        case .full:
            return .full
        @unknown default:
            return .unknown
        }
    }
}
