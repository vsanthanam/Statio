//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

struct MockCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum MockCommandError: Error, RepoError {
        case noInputs
        case noOutputs

        var message: String {
            switch self {
            case .noInputs:
                return "No paths to mock! Suply a config file or use --output"
            case .noOutputs:
                return "No mock destination! Suppy a config file or use --inputs"
            }
        }
    }

    @Argument(help: "Mock destination")
    var outputs: [String] = []

    @Argument(help: "Files to mock")
    var inputs: [String] = []

    @Option(name: .long, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Option(name: .long, help: "Mockolo")
    var bin: String = "bin/mockolo/mockolo"

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    func generateMocks() throws {
        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)

        var paths = [String]()

        if !inputs.isEmpty {
            paths = inputs
        } else if let configuration = configuration {
            paths.append(configuration.featureCodePath)
            paths.append(configuration.libraryCodePath)
        } else {
            throw MockCommandError.noInputs
        }

        var destinations = [String]()

        if !outputs.isEmpty {
            destinations = outputs
        } else if let configuration = configuration {
            destinations = configuration.mockolo.destinations
        } else {
            throw MockCommandError.noOutputs
        }

        let joinedPaths = paths.map { ["--sourcedirs", $0].joined(separator: " ") }.joined(separator: " ")
        let baseCommand = "\(bin) " + joinedPaths

        for destination in destinations {
            var command = baseCommand + " --destination \(destination)"
            if let imports = configuration?.mockolo.testableImports {
                command += " "
                let imports = imports.map { ["--testable-imports", $0].joined(separator: " ") }.joined(separator: " ")
                command += imports
            }
            command += " --macro DEBUG --annotation CreateMock"
            try shell(script: command,
                      at: repoRoot,
                      errorMessage: "Mockolo failed!",
                      verbose: trace)
        }
    }

    // MARK: - ParsableCommand

    static let configuration: CommandConfiguration = .init(commandName: "mocks",
                                                           abstract: "Generate mocks",
                                                           version: "2.0")

    // MARK: - RepoCommand

    func action() throws {
        try generateMocks()
        complete(with: "Mocks Generated! 🍻")
    }
}
