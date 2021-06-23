//
// Aro
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct CleanCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum CleanCommandError: Error, RepoError {
        case missingWorkspaceConfiguration

        var message: String {
            switch self {
            case .missingWorkspaceConfiguration:
                return "Missing workspace from arguments or configuration!"
            }
        }
    }

    @Option(name: .long, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    @Option(name: .long, help: "Workspace Root")
    var workspaceRoot: String?

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "clean",
                                                    abstract: "Clean the repo")

    // MARK: - RepoCommand

    func action() throws {

        let config = try fetchConfiguration(on: repoRoot, location: toolConfiguration)
        guard let workspace = workspaceRoot ?? config?.workspaceRoot else {
            throw CleanCommandError.missingWorkspaceConfiguration
        }

        let tuistDir = [workspace, "Tuist"].joined(separator: "/")

        let clean = """
        #! /bin/sh
        swiftlint=.swiftlint.yml
        swiftforamt=.swiftformat
        tuist=\(tuistDir)
        if [ -f "$swiftlint" ]; then
            rm $swiftlint
        fi
        if [ -f "$swiftformat" ]; then
            rm $swiftformat
        fi
        if [ -f "tuist" ]; then
            rm -r $tuist
        fi
        find \(workspace) -type d -name \'*.xcodeproj\' -prune -exec rm -rf {} \\;
        find \(workspace) -type d -name \'*.xcworkspace\' -prune -exec rm -rf {} \\;
        """

        try shell(script: clean, at: repoRoot, verbose: trace)
        complete(with: "Clean Complete! 🍻")
    }
}
