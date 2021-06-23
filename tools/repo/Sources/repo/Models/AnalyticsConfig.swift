//
// Aro
// Varun Santhanam
//

import Foundation

public struct AnalyticsConfig: Codable, Equatable {
    let appKey: String?
    let host: String?

    static var empty: AnalyticsConfig {
        .init(appKey: nil, host: nil)
    }
}

public func == (lhs: AnalyticsConfig, rhs: AnalyticsConfig) -> Bool {
    lhs.host == rhs.host && lhs.appKey == rhs.appKey
}
