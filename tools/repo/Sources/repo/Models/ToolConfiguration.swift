//
// Statio
// Varun Santhanam
//

import Foundation
import ShellOut

/// The configuration object model
struct ToolConfiguration: Codable {

    /// SwiftFormat configuration
    let lint: LintConfiguration

    /// Mockolo configuration
    let mockolo: MockoloConfiguration

    /// Test configuration
    let testConfig: TestConfiguration

    /// DI graph source path
    let diGraphPath: String

    /// Path to source that consume the DI graoh
    let diCodePath: String

    /// Vendor code path
    let vendorCodePath: String

    /// Feature code path
    let featureCodePath: String

    /// Library code path
    let libraryCodePath: String

    /// Root app directory
    let workspaceRoot: String
}
