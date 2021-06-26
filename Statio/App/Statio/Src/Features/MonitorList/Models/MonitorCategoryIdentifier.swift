//
// Statio
// Varun Santhanam
//

import Foundation

enum MonitorCategoryIdentifier: String, Identifiable, Equatable, Hashable, CustomStringConvertible, CaseIterable {

    case identity
    case system
    case network
    case motion
    case location

    typealias ID = String

    var id: ID { rawValue }

    static func == (lhs: MonitorCategoryIdentifier, rhs: MonitorCategoryIdentifier) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var description: String { id }
}
