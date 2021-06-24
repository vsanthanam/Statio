//
// Statio
// Varun Santhanam
//

import Foundation

struct LintConfiguration: Codable {

    /// Directories to exclude from linting
    var excludeDirs: [String]

    /// SwiftLint configuration
    let swiftlint: SwiftLint

    /// SwiftFormat configuration
    let swiftformat: SwiftFormat

    /// SwiftFormat configuration
    struct SwiftFormat: Codable {

        /// Rules to enable
        let enableRules: [String]

        /// Rules to disable
        let disableRules: [String]

        /// Swift version
        let swiftVersion: String
    }

    struct SwiftLint: Codable {

        /// Disabled rules
        let disabledRules: [String]

        /// Opt-In Rules
        let optInRules: [String]
    }

}
