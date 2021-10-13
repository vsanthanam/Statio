//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
protocol ByteFormatting: AnyObject {
    func formattedBytesForDisk(_ bytes: UInt64) -> String
    func formattedBytesForMemory(_ bytes: UInt64) -> String
}

final class ByteFormatter: ByteFormatting {

    func formattedBytesForDisk(_ bytes: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: .init(bytes), countStyle: .file)
    }

    func formattedBytesForMemory(_ bytes: UInt64) -> String {
        ByteCountFormatter.string(fromByteCount: .init(bytes), countStyle: .memory)
    }

}
