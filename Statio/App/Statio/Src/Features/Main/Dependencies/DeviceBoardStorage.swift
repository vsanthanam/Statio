//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import Logging

/// @mockable
protocol DeviceBoardStoring: AnyObject {
    func retrieveCachedBoards() throws -> [DeviceBoard]
}

/// @mockable
protocol MutableDeviceBoardStoring: DeviceBoardStoring {
    func storeBoards(_ boards: [DeviceBoard]) throws
}

final class DeviceBoardStorage: MutableDeviceBoardStoring {

    // MARK: - DeviceBoardStoring

    func retrieveCachedBoards() throws -> [DeviceBoard] {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            loggedAssertionFailure("Couldn't locate documents directory", key: "missing_documents_directory")
            return []
        }
        let boardsUrl = documentsUrl.appendingPathComponent("device_boards.json", isDirectory: false)
        guard let data = FileManager.default.contents(atPath: boardsUrl.path) else {
            return []
        }
        return try JSONDecoder().decode([DeviceBoard].self, from: data)
    }

    // MARK: - MutableDeviceBoardStoring

    func storeBoards(_ boards: [DeviceBoard]) throws {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let boardsUrl = documentsUrl.appendingPathComponent("device_boards.json", isDirectory: false)
        try? FileManager.default.removeItem(at: boardsUrl)
        let data = try JSONEncoder().encode(boards)
        try data.write(to: boardsUrl)
    }
}
