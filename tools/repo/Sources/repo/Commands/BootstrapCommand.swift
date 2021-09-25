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

        guard let mockCommand = (try MockCommand.parseAsRoot(.init(arguments)) as? MockCommand) else {
            throw CustomRepoError.unknown
        }

        guard let dependencyGraphCommand = (try DependencyGraphCommand.parseAsRoot(.init(arguments)) as? DependencyGraphCommand) else {
            throw CustomRepoError.unknown
        }

        guard let projectCommand = (try ProjectCommand.parseAsRoot(.init(arguments)) as? ProjectCommand) else {
            throw CustomRepoError.unknown
        }

        try mockCommand.action()

        try dependencyGraphCommand.action()

        try projectCommand.action()
        complete(with: "Bootstrapping complete! 🍻\nOpen Statio.xcworkspace and begin development!")
    }
}
