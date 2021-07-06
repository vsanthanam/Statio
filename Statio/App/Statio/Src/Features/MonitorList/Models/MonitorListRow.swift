//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

struct MonitorListRow: Equatable, Hashable {

    let identifier: MonitorIdentifier
    let name: String
    let icon: UIImage

    // MARK: - Equatable

    static func == (lhs: MonitorListRow, rhs: MonitorListRow) -> Bool {
        lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.icon == rhs.icon
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(name)
        hasher.combine(icon)
    }
}
