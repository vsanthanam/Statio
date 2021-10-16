//
// Statio
// Varun Santhanam
//

import Foundation
import MonitorKit

/// @CreateMock
protocol MemoryProviding: AnyObject {
    func record() throws -> Memory.Usage
}

final class MemoryProvider: MemoryProviding {
    func record() throws -> Memory.Usage {
        try Memory.record()
    }
}
