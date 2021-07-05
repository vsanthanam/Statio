//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

enum AppState: CaseIterable, Identifiable, Equatable, Hashable {

    // MARK: - Cases

    case monitor

    case settings

    // MARK: - API

    var viewModel: MainTabViewModel {
        switch self {
        case .monitor:
            return .init(title: "Monitor",
                         image: UIImage(systemName: "magnifyingglass",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.imageWithoutBaseline(),
                         tag: 0)
        case .settings:
            return .init(title: "Settings",
                         image: UIImage(systemName: "gear",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.imageWithoutBaseline(),
                         tag: 1)
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
