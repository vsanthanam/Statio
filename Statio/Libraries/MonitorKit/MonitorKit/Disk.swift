//
// Statio
// Varun Santhanam
//

import Foundation

public enum Disk {

    public enum Error: Swift.Error {
        case unknown
    }

    public struct Usage: Equatable, Hashable {

        public init(total: UInt64,
                    opportunisticAvailable: UInt64,
                    importantAvailable: UInt64,
                    available: UInt64) {
            self.total = total
            self.opportunisticAvailable = opportunisticAvailable
            self.importantAvailable = importantAvailable
            self.available = available
        }

        public let total: UInt64
        public let opportunisticAvailable: UInt64
        public let importantAvailable: UInt64
        public let available: UInt64

    }

    public static func record() throws -> Usage {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        let values = try fileURL.resourceValues(forKeys: [.volumeTotalCapacityKey,
                                                          .volumeAvailableCapacityForImportantUsageKey,
                                                          .volumeAvailableCapacityForOpportunisticUsageKey,
                                                          .volumeAvailableCapacityKey])
        guard let total = values.volumeTotalCapacity.map(UInt64.init),
              let opportunisticAvailable = values.volumeAvailableCapacityForOpportunisticUsage.map(UInt64.init),
              let importantAvailable = values.volumeAvailableCapacityForImportantUsage.map(UInt64.init),
              let available = values.volumeAvailableCapacity.map(UInt64.init) else {
            throw Error.unknown
        }
        return .init(total: total,
                     opportunisticAvailable: opportunisticAvailable,
                     importantAvailable: importantAvailable,
                     available: available)

    }
}
