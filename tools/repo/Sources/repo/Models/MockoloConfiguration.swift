//
// Aro
// Varun Santhanam
//

import Foundation

/// Mockolo Configuration
struct MockoloConfiguration: Codable {

    /// @testable modules to import
    let testableImports: [String]

    /// Locations to write mocks
    let destinations: [String]
}
