//
// Statio
// Varun Santhanam
//

import Foundation

enum AppState: CaseIterable {

    case monitor

    case settings

    var tabViewModel: MainTabViewModel {
        switch self {
        case .monitor:
            return .init(title: "Monitor", tag: 0)
        case .settings:
            return .init(title: "Settings", tag: 1)
        }
    }
}
