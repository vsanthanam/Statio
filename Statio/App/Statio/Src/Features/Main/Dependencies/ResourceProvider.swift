//
// Statio
// Varun Santhanam
//

import Foundation

/// @mockable
protocol ResourceProviding: AnyObject {
    func url(forResource name: String, type: String) -> URL?
    func data(forResource name: String, type: String) -> Data?
}

final class ResourceProvider: ResourceProviding {

    // MARK: - ResourceProviding

    func url(forResource name: String, type: String) -> URL? {
        Bundle.main.url(forResource: name, withExtension: type)
    }

    func data(forResource name: String, type: String) -> Data? {
        guard let url = url(forResource: name, type: type) else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
