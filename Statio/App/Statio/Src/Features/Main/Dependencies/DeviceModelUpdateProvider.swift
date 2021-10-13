//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
protocol DeviceModelUpdateProviding: AnyObject {
    var host: String { get }
    var path: String { get }
}

final class DeviceModelUpdateProvider: DeviceModelUpdateProviding {
    var host: String { "https://vsanthanam.github.io" }
    var path: String { "/statio-device-list/models.json" }
}
