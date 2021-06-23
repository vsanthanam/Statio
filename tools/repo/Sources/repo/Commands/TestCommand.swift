//
// Aro
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct TestCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum TestCommandError: Error, RepoError {
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

    @Option(name: .long, help: "Simulator Version")
    var os: String?

    @Option(name: .long, help: "Workspace Root")
    var workspaceRoot: String?

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    @Flag(name: .long, help: "Display pretty results (requires xcbeautify)")
    var pretty: Bool = false

    // MARK: - ParsableCommand

    static let configuration: CommandConfiguration = .init(commandName: "test",
                                                           abstract: "Run the unit tests",
                                                           version: "2.0")

    // MARK: - RepoCommand

    func action() throws {
        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)
        let configDevice = self.device ?? configuration?.testConfig.device
        let configOs = self.os ?? configuration?.testConfig.os
        let workspaceRoot = self.workspaceRoot ?? configuration?.workspaceRoot

        guard let workspace = workspaceRoot else {
            throw TestCommandError.missingWorkspace
        }

        guard let device = configDevice else {
            throw TestCommandError.missingSimulatorName
        }

        guard let os = configOs else {
            throw TestCommandError.missingOs
        }

        let command: String

        if pretty {
            command = "set -o pipefail && xcodebuild -workspace \(workspace)/Aro.xcworkspace -sdk iphonesimulator -scheme Aro -destination 'platform=iOS Simulator,name=\(device),OS=\(os)' test | xcbeautify"
        } else {
            command = "xcodebuild -workspace \(workspace)/Aro.xcworkspace -sdk iphonesimulator -scheme Aro -destination 'platform=iOS Simulator,name=\(device),OS=\(os)' test"
        }

        try shell(script: command, at: repoRoot, errorMessage: "Testing failed!", verbose: true)
    }
}
