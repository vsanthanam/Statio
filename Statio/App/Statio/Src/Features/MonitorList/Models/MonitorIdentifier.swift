//
// Statio
// Varun Santhanam
//

import Foundation

enum MonitorIdentifier: String, Identifiable, Equatable, Hashable, CustomStringConvertible, CaseIterable {

    // MARK: - Cases

    case memory
    case battery
    case disk
    case processor
    case carrier
    case identity
    case cellular
    case wifi
    case accelerometer
    case gyroscope
    case magnometer
    case map
    case gps

    var category: MonitorCategoryIdentifier {
        switch self {
        case .identity, .carrier:
            return .identity
        case .processor, .memory, .disk, .battery:
            return .system
        case .cellular, .wifi:
            return .network
        case .accelerometer, .gyroscope, .magnometer:
            return .motion
        case .map, .gps:
            return .location
        }
    }

    // MARK: - Identifiable

    typealias ID = String

    var id: ID { rawValue }

    // MARK: - Equatable

    public static func == (lhs: MonitorIdentifier, rhs: MonitorIdentifier) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MARK: - CustomStringConvertible

    var description: String { id }

}