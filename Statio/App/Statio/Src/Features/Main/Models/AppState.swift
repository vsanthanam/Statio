//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

enum AppState: CaseIterable, Identifiable, Equatable, Hashable {

    // MARK: - Cases

    case monitor

    case reporter

    case settings

    // MARK: - API

    var viewModel: MainTabViewModel {
        switch self {
        case .monitor:
            return .init(title: "Monitor",
                         image: UIImage(systemName: "magnifyingglass",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.imageWithoutBaseline(),
                         tag: 0)
        case .reporter:
            return .init(title: "Reporter",
                         image: UIImage(systemName: "magnifyingglass",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.imageWithoutBaseline(),
                         tag: 1)
        case .settings:
            return .init(title: "Settings",
                         image: UIImage(systemName: "gear",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.imageWithoutBaseline(),
                         tag: 2)
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
