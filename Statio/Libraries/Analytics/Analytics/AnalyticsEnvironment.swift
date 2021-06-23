//
// Aro
// Varun Santhanam
//

import AppFoundation

enum EnvironmentVariablesAnanalytics: EnvironmentVariable {

    // MARK: - API

    case sendInDebug

    // MARK: - EnvironmentVariable

    static var namespace: String? {
        "AN"
    }

    var key: String {
        switch self {
        case .sendInDebug:
            return "SEND_IN_DEBUG"
        }
    }
}

typealias AnalyticsEnvironment = BaseEnvironment<EnvironmentVariablesAnanalytics>
