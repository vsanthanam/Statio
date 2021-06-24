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

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Option(name: .long, help: "Simulator Device Name")
    var device: String?

    @Option(name: .long, help: "Workspace Root")
    var workspaceRoot: String?

    @Option(name: .long, help: "Simulator Version")
    var os: String?

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
        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)
        let configDevice = self.device ?? configuration?.testConfig.device
        let configOs = self.os ?? configuration?.testConfig.os
        let workspaceRoot = self.workspaceRoot ?? configuration?.workspaceRoot

        guard let workspace = workspaceRoot else {
            throw TestScriptCommandError.missingWorkspace
        }

        guard let device = configDevice else {
            throw TestScriptCommandError.missingSimulatorName
        }

        guard let os = configOs else {
            throw TestScriptCommandError.missingOs
        }

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
        ./repo update-deps --trace
        ./repo mock --trace
        ./repo develop -d --trace
        """

        let testCommand: String

        if pretty {
            testCommand = "xcodebuild -workspace \(workspace)/Statio.xcworkspace -sdk iphonesimulator -scheme Statio -destination 'platform=iOS Simulator,name=\(device),OS=\(os)' test | xcbeautify"
        } else {
            testCommand = "xcodebuild -workspace \(workspace)/Statio.xcworkspace -sdk iphonesimulator -scheme Statio -destination 'platform=iOS Simulator,name=\(device),OS=\(os)' test"
        }

        script += "\n\(testCommand)"

        if autoclean {
            script += "\n./repo clean"
        }

        write(message: script)
    }

}
