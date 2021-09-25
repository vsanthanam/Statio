//
// Statio
// Varun Santhanam
//

import Foundation

enum DiskListRow: Equatable, Hashable {

    case gaugeData(Double, String)
    case legendEntry(String, String)

    // MARK: - Equatable

    static func == (lhs: DiskListRow, rhs: DiskListRow) -> Bool {
        switch (lhs, rhs) {
        case let (.gaugeData(ld, ls), .gaugeData(rd, rs)):
            return ld == rd && ls == rs
        case let (.legendEntry(lLabel, lData), .legendEntry(rLabel, rData)):
            return lLabel == rLabel && lData == rData
        case (.gaugeData, _),
             (.legendEntry, _):
            return false
        }
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        switch self {
        case let .gaugeData(percentage, label):
            hasher.combine(#line)
            hasher.combine(percentage)
            hasher.combine(label)
        case let .legendEntry(label, value):
            hasher.combine(#line)
            hasher.combine(label)
            hasher.combine(value)
        }
    }
}
