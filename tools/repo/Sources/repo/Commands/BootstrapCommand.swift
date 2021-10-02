//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation

struct BootstrapCommand: ParsableCommand, RepoCommand {

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "bootstrap",
                                                    abstract: "Prepare the repo for development")

    // MARK: - RepoCommand

    func action() throws {
        let arguments = CommandLine.arguments.dropFirst(2)

        guard var cleanCommand = (try CleanCommand.parseAsRoot(.init(arguments)) as? CleanCommand) else {
            throw CustomRepoError.unknown
        }

        guard var mockCommand = (try MockCommand.parseAsRoot(.init(arguments)) as? MockCommand) else {
            throw CustomRepoError.unknown
        }

        guard var dependencyGraphCommand = (try DependencyGraphCommand.parseAsRoot(.init(arguments)) as? DependencyGraphCommand) else {
            throw CustomRepoError.unknown
        }

        guard var projectCommand = (try ProjectCommand.parseAsRoot(.init(arguments)) as? ProjectCommand) else {
            throw CustomRepoError.unknown
        }

        cleanCommand.trace = true
        try cleanCommand.action()

        mockCommand.trace = true
        try mockCommand.action()

        dependencyGraphCommand.trace = true
        try dependencyGraphCommand.action()

        projectCommand.trace = true
        try projectCommand.action()
        complete(with: "Bootstrapping complete! 🍻\nOpen Statio.xcworkspace and begin development!")
    }
}
