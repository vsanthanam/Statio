//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation

/// @mockable
protocol DeviceModelStoring: AnyObject {
    func retrieveCachedModels() throws -> [DeviceModel]
}

/// @mockable
protocol MutableDeviceModelStoring: DeviceModelStoring {
    func storeModels(_ models: [DeviceModel]) throws
}

final class DeviceModelStorage: MutableDeviceModelStoring {

    // MARK: - DeviceModelStoring

    func retrieveCachedModels() throws -> [DeviceModel] {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            loggedAssertionFailure("Couldn't locate documents directory", key: "missing_documents_directory")
            return []
        }
        guard let data = FileManager.default.contents(atPath: directory.path) else {
            return []
        }
        return try JSONDecoder().decode([DeviceModel].self, from: data)
    }

    // MARK: - MutableDeviceModelStoring

    func storeModels(_ models: [DeviceModel]) throws {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        try? FileManager.default.removeItem(at: directory)
        let data = try JSONEncoder().encode(models)
        try data.write(to: directory)
    }

}
