//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct DevelopCommand: ParsableCommand, RepoCommand {

    // MARK: - Initializers

    init() {}

    // MARK: - API

    enum DevelopCommandError: Error, RepoError {
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

    @Flag(name: .shortAndLong, help: "Don't automatically open Xcode")
    var dontOpenXcode: Bool = false

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "develop",
                                                    abstract: "Generate the project",
                                                    version: "2.0")

    func action() throws {

        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)

        guard let workspace = workspaceRoot ?? configuration?.workspaceRoot else {
            throw DevelopCommandError.noWorkspace
        }

        try tuist(on: repoRoot,
                  bin: bin,
                  toolConfig: toolConfiguration,
                  generationOptions: configuration?.tuist.generationOptions ?? [],
                  workspace: workspace,
                  verbose: trace)

        if !dontOpenXcode {
            _ = try? shell(script: "open \(workspace)/Statio.xcworkspace", at: repoRoot)
        }

        complete(with: "Project Generated! 🍻")
    }
}
