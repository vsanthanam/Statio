//
// Statio
// Varun Santhanam
//

import Foundation

public struct DeviceModel: Codable, Equatable, Identifiable, Hashable {

    // MARK: - API

    public var name: String
    public var identifier: String

    // MARK: - Identifiable

    public typealias ID = String

    public var id: String { identifier }

    // MARK: - Equatable

    public static func == (lhs: DeviceModel, rhs: DeviceModel) -> Bool {
        lhs.name == rhs.name && lhs.identifier == rhs.identifier
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(identifier)
    }
}
