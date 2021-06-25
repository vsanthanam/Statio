//
// Statio
// Varun Santhanam
//

import Foundation

struct DeviceBoard: Codable, Equatable, Hashable, Identifiable {

    // MARK: - API

    var identifier: String
    var name: String
    var part: String
    var frequency: Int

    // MARK: - Identifiable

    typealias ID = String

    var id: ID { identifier }

    // MARK: - Equatable

    static func == (lhs: DeviceBoard, rhs: DeviceBoard) -> Bool {
        lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.part == rhs.part && lhs.frequency == rhs.frequency
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(name)
        hasher.combine(part)
        hasher.combine(frequency)
    }

}
