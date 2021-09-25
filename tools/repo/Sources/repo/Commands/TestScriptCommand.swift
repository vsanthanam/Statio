//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation

struct TestScriptCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum TestScriptCommandError: Error, RepoError {
        case missingSimulatorName
        case missingOs
        case missingWorkspace

        var message: String {
            switch self {
            case .missingSimulatorName:
                return "Missing simulator name in arguments or configuration!"
            case .missingOs:
                return "Missing device os in arguments or configuration!"
            case .missingWorkspace:
                return "Missing workspace in arguments or configuration!"
            }
        }
    }

    @Option(name: .long, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Flag(name: .long, help: "Allow lint failure in test script")
    var relaxed: Bool = false

    @Flag(name: .long, help: "Display pretty results (requires xcbeautify)")
    var pretty: Bool = false

    @Flag(name: .long, help: "Automatically clean repo when tests are complete")
    var autoclean: Bool = false

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "test-script",
                                                    abstract: "Write the suggested CI script to STDOUT")

    // MARK: - RepoCommand

    func action() throws {
        var script: String = """
        #! /bin/sh
        set -euo pipefail
        """

        if !relaxed {
            script += "\n./repo lint --trace"
        }

        script += "\n"

        script += """
        ./repo analytics wipe
        ./repo generate deps --trace
        ./repo generate mocks --trace
        ./repo generate project --trace
        """

        let testCommand: String

        if pretty {
            testCommand = "./repo test --pretty"
        } else {
            testCommand = "./repo test"
        }

        script += "\n\(testCommand)"

        if autoclean {
            script += "\n./repo clean"
        }

        write(message: script)
    }

}
