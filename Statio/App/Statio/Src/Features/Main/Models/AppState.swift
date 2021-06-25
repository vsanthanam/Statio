//
// Statio
// Varun Santhanam
//

import Foundation

enum AppState: CaseIterable, Identifiable, Equatable, Hashable {

    // MARK: - Cases

    case monitor

    case settings

    // MARK: - API

    var viewModel: MainTabViewModel {
        switch self {
        case .monitor:
            return .init(title: "Monitor", tag: 0)
        case .settings:
            return .init(title: "Settings", tag: 1)
        }
    }

    // MARK: - Identifiable

    typealias ID = Int

    var id: Int { viewModel.tag }

    // MARK: - Equatable

    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
