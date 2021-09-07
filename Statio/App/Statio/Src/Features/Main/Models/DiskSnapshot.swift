//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

@dynamicMemberLookup
struct DiskSnapshot: Equatable, Hashable {

    // MARK: - Initializers

    init(usage: Disk.Usage, timestamp: Date) {
        self.usage = usage
        self.timestamp = timestamp
    }

    // MARK: - API

    let usage: Disk.Usage

    let timestamp: Date

    // MARK: - DynamicMemberLookup

    subscript<T>(dynamicMember member: KeyPath<Disk.Usage, T>) -> T {
        usage[keyPath: member]
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
        hasher.combine(usage)
    }

    // MARK: - Equatable

    static func == (lhs: DiskSnapshot, rhs: DiskSnapshot) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.usage == rhs.usage
    }

}
