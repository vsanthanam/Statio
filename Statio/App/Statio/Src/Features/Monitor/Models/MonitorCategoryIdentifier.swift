//
// Statio
// Varun Santhanam
//

import Foundation

enum MonitorCategoryIdentifier: String, Identifiable, Equatable, Hashable, CustomStringConvertible, CaseIterable {

    // MARK: - Cases

    case identity
    case system
    case network
    case motion
    case location

    // MARK: - Identifiable

    typealias ID = String

    var id: ID { rawValue }

    // MARK: - Equatable

    static func == (lhs: MonitorCategoryIdentifier, rhs: MonitorCategoryIdentifier) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - CustomStringConvertible

    var description: String { id }
}
