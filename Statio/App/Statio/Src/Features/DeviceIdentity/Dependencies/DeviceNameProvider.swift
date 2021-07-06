//
// Statio
// Varun Santhanam
//

import Foundation
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
        DeviceInfo.name
    }

    var modelIdentifier: String {
        DeviceInfo.identifier
    }

    var os: String {
        DeviceInfo.systemInfo.name
    }

    var version: String {
        DeviceInfo.systemInfo.version
    }
}
