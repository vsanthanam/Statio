//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation

struct GenerateCommand: ParsableCommand, RepoCommand {

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "generate",
                                                    version: "2.0",
                                                    subcommands: [ProjectCommand.self,
                                                                  DependencyGraphCommand.self,
                                                                  MockCommand.self])

    // MARK: - RepoCommand

    func action() throws {
        write(message: "Welcome to Statio's Code Generator! Run ./repo generate -h for more options")
    }

}
