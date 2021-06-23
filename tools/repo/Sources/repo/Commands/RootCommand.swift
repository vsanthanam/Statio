//
// Aro
// Varun Santhanam
//

import ArgumentParser
import Foundation

struct RootCommand: ParsableCommand, RepoCommand {

    // MARK: - ParsableCommand

    static let configuration = CommandConfiguration(commandName: "Repo",
                                                    version: "2.0",
                                                    subcommands: [BootstrapCommand.self,
                                                                  DevelopCommand.self,
                                                                  DependencyGraphCommand.self,
                                                                  MockCommand.self,
                                                                  LintCommand.self,
                                                                  TestCommand.self,
                                                                  AnalyticsCommand.self,
                                                                  CleanCommand.self,
                                                                  TestScriptCommand.self])

    // MARK: - RepoCommand

    func action() throws {
        write(message: "Welcome to Aro! Run ./repo -h for more options")
    }
}
