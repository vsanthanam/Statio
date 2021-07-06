//
// Statio
// Varun Santhanam
//

import Foundation

struct DeviceIdentityRow: Hashable, Equatable {

    let title: String
    let value: String

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(value)
    }

    // MARK: - Equatable

    static func == (lhs: DeviceIdentityRow, rhs: DeviceIdentityRow) -> Bool {
        lhs.title == rhs.title && lhs.value == rhs.value
    }

}
