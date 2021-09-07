//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

@dynamicMemberLookup
struct MemorySnapshot: Equatable, Hashable {

    // MARK: - Initializers

    init(usage: Memory.Usage, timestamp: Date) {
        self.usage = usage
        self.timestamp = timestamp
    }

    // MARK: - API

    let usage: Memory.Usage

    let timestamp: Date

    // MARK: - DynamicMemberLookup

    subscript<T>(dynamicMember member: KeyPath<Memory.Usage, T>) -> T {
        usage[keyPath: member]
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
        hasher.combine(usage)
    }

    // MARK: - Equatable

    static func == (lhs: MemorySnapshot, rhs: MemorySnapshot) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.usage == rhs.usage
    }
}
