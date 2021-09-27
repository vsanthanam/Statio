//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

@dynamicMemberLookup
struct ProcessorSnapshot: Equatable, Hashable {

    // MARK: - Initializers

    init(usage: Processor.Usage,
         timestamp: Date) {
        self.usage = usage
        self.timestamp = timestamp
    }

    // MARK: - API

    let usage: Processor.Usage

    let timestamp: Date

    func usage(forCore core: Int) -> Processor.Usage.CoreUsage? {
        usage.usage(forCore: core)
    }

    // MARK: - DynamicMemberLookup

    subscript<T>(dynamicMember member: KeyPath<Processor.Usage, T>) -> T {
        usage[keyPath: member]
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
        hasher.combine(usage)
    }

    // MARK: - Equatable

    static func == (lhs: ProcessorSnapshot, rhs: ProcessorSnapshot) -> Bool {
        lhs.timestamp == rhs.timestamp && lhs.usage == rhs.usage
    }
}
