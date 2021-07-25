//
// Statio
// Varun Santhanam
//

import Foundation

extension UInt64 {
    var asCountedMemory: String {
        ByteCountFormatter.string(fromByteCount: .init(self), countStyle: .memory)
    }
}
