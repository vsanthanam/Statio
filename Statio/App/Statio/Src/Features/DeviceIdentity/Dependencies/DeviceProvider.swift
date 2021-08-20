//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit
import UIKit

/// @mockable
protocol DeviceProviding: AnyObject {
    var deviceName: String { get }
    var modelIdentifier: String { get }
    var os: String { get }
    var version: String { get }
}

final class DeviceProvider: DeviceProviding {

    // MARK: - DeviceNameProviding

    var deviceName: String {
        Device.name
    }

    var modelIdentifier: String {
        Device.identifier
    }

    var os: String {
        Device.system.name
    }

    var version: String {
        Device.system.version
    }
}
