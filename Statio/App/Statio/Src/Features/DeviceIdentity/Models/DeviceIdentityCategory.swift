//
// Statio
// Varun Santhanam
//

import Foundation

enum DeviceIdentityCategory: String, Hashable, Equatable {

    // MARK: - Cases

    case hardware
    case software

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    // MARK: - Equatable

    static func == (lhs: DeviceIdentityCategory, rhs: DeviceIdentityCategory) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
