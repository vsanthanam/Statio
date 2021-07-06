//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

/// @mockable
protocol DeviceNameProviding: AnyObject {
    func buildLatestName() -> String
}

final class DeviceNameProvider: DeviceNameProviding {

    // MARK: - DeviceNameProviding

    func buildLatestName() -> String {
        UIDevice.current.name
    }
}
