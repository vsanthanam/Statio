//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
protocol ResourceProviding: AnyObject {
    func url(forResource name: String, type: String) -> URL?
    func data(forURL url: URL) -> Data?
}

final class ResourceProvider: ResourceProviding {

    // MARK: - ResourceProviding

    func url(forResource name: String, type: String) -> URL? {
        Bundle.main.url(forResource: name, withExtension: type)
    }

    func data(forURL url: URL) -> Data? {
        try? Data(contentsOf: url)
    }
}
