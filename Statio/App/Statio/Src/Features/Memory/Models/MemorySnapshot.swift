//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

@dynamicMemberLookup
struct MemorySnapshot: Equatable, Hashable {

    init(usage: Memory.Usage, timestamp: Date) {
        self.usage = usage
        self.timestamp = timestamp
    }

    let usage: Memory.Usage
    let timestamp: Date

    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
        hasher.combine(usage)
    }

    static func == (lhs: MemorySnapshot, rhs: MemorySnapshot) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.usage == rhs.usage
    }

    subscript<T>(dynamicMember member: KeyPath<Memory.Usage, T>) -> T {
        usage[keyPath: member]
    }

}
