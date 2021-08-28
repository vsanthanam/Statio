//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

extension Memory.Usage {

    var used: UInt64 {
        wired + inactive + active
    }

    var available: UInt64 {
        used + free
    }

    var reserved: UInt64 {
        physical - available
    }

    var pressure: Double {
        (Double)(used + reserved) / (Double)(physical)
    }

    var adjustedMemoryPressure: Double {
        (Double)(wired + active) / (Double)(available)
    }
}
