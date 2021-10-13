//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
protocol DeviceBoardUpdateProviding: AnyObject {
    var host: String { get }
    var path: String { get }
}

final class DeviceBoardUpdateProvider: DeviceBoardUpdateProviding {
    var host: String { "https://vsanthanam.github.io" }
    var path: String { "/statio-device-list/boards.json" }
}
