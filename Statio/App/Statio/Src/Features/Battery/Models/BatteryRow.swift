//
// Statio
// Varun Santhanam
//

import Foundation

struct BatteryRow: Hashable, Equatable {

    let title: String
    let value: String

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(value)
    }

    // MARK: - Equatable

    static func == (lhs: BatteryRow, rhs: BatteryRow) -> Bool {
        lhs.title == rhs.title && lhs.value == rhs.value
    }

}
