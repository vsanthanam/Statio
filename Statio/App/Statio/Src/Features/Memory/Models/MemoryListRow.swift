//
// Statio
// Varun Santhanam
//

import Foundation

enum MemoryListRow: Equatable, Hashable {

    case chartData([(String, UInt64)])
    case legendEntry(String, String)

    // MARK: - Equatable

    static func == (lhs: MemoryListRow, rhs: MemoryListRow) -> Bool {
        switch (lhs, rhs) {
        case let (.chartData(ld), .chartData(rd)):
            return ld.map(\.0) == rd.map(\.0) && ld.map(\.1) == rd.map(\.1)
        case let (.legendEntry(lLabel, lData), .legendEntry(rLabel, rData)):
            return lLabel == rLabel && lData == rData
        case (.chartData, _), (.legendEntry, _):
            return false
        }
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .chartData(data):
            hasher.combine(#line)
            for entry in data {
                hasher.combine(entry.0)
                hasher.combine(entry.1)
            }
        case let .legendEntry(label, value):
            hasher.combine(#line)
            hasher.combine(label)
            hasher.combine(value)
        }
    }
}
