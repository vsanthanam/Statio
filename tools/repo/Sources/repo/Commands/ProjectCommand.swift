//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct ProjectCommand: ParsableCommand, RepoCommand {

    // MARK: - Initializers

    init() {}

    // MARK: - API

    enum ProjectCommandError: Error, RepoError {
        case noWorkspace

        var message: String {
            switch self {
            case .noWorkspace:
                return "No workspace specified in configuration or arguments!"
            }
        }
    }

    @Option(name: .shortAndLong, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Option(name: .long, help: "Workspace Root")
    var workspaceRoot: String?

    @Option(name: .long, help: "Tuist")
    var bin: String = "bin/tuist/tuist"

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "project",
                                                    abstract: "Generate the project",
                                                    version: "2.0")

    func action() throws {

        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)

        guard let workspace = workspaceRoot ?? configuration?.workspaceRoot else {
            throw ProjectCommandError.noWorkspace
        }

        try tuist(on: repoRoot,
                  bin: bin,
                  toolConfig: toolConfiguration,
                  workspace: workspace,
                  verbose: trace)

        complete(with: "Project Generated! 🍻")
    }
}
