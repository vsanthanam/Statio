//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit
import UIKit

/// @mockable
protocol DeviceStaticInfoProviding: AnyObject {
    var deviceName: String { get }
    var modelIdentifier: String { get }
    var os: String { get }
    var version: String { get }
}

final class DeviceStaticInfoProvider: DeviceStaticInfoProviding {

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
