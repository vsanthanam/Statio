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

        /// A custom lint rule
        struct Rule: Codable {
            let name: String
            let regex: String
            let message: String
        }

        /// Disabled rules
        let disabledRules: [String]

        /// Opt-In Rules
        let optInRules: [String]

        /// Custom Regex Warning Rules
        let warnings: [Rule]

        /// Custom Regex Error Rules
        let errors: [Rule]
    }

}
