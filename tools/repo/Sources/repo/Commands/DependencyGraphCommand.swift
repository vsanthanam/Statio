//
// Aro
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct DependencyGraphCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum DependencyGraphCommandError: Error, RepoError {
        case noInput
        case noOutput

        var message: String {
            switch self {
            case .noInput:
                return "No configuration file or input argument"
            case .noOutput:
                return "No configuration file or output argument"
            }
        }
    }

    @Argument(help: "Generated code destination")
    var output: String?

    @Argument(help: "Files to examine")
    var input: String?

    @Option(name: .long, help: "Needle")
    var bin: String = "bin/needle/needle"

    @Option(name: .long, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    // MARK: - ParsableCommand

    static let configuration: CommandConfiguration = .init(commandName: "update-deps",
                                                           abstract: "Run needle and update the runtime dependency graph",
                                                           version: "2.0")

    // MARK: - RepoCommand

    func action() throws {
        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)
        guard let needleSource = input ?? configuration?.diCodePath else {
            throw DependencyGraphCommandError.noInput
        }
        guard let dependencyGraph = output ?? configuration?.diGraphPath else {
            throw DependencyGraphCommandError.noOutput
        }
        let command = "export SOURCEKIT_LOGGING=0 && \(bin) generate \(dependencyGraph) \(needleSource)"
        try shell(script: command,
                  at: repoRoot,
                  errorMessage: "Needle failed!",
                  verbose: trace)
        complete(with: "Dependency Graph Updated! 🍻")
    }
}
