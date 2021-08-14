//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

/// @mockable
protocol MemoryProviding: AnyObject {
    func record() throws -> Memory.Snapshot
}

final class MemoryProvider: MemoryProviding {
    func record() throws -> Memory.Snapshot {
        try Memory.record()
    }
}
