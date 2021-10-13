//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
protocol MonitorTitleProviding: AnyObject {
    func title(for identifier: MonitorIdentifier) -> String
}

final class MonitorTitleProvider: MonitorTitleProviding {

    // MARK: - MonitorTitleProviding

    func title(for identifier: MonitorIdentifier) -> String {
        identifier.rawValue.capitalized
    }
}
