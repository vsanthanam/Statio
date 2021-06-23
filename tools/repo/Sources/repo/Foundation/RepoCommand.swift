//
// Aro
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut

protocol RepoError: Error {
    var message: String { get }
}

struct CustomRepoError: RepoError {
    let message: String

    static let unknown: CustomRepoError = .init(message: "Unknown Error")
}

protocol RepoCommand {
    func action() throws
}

extension RepoCommand {
    func execute(_ action: () throws -> Void) throws {
        do {
            try action()
        } catch {
            if let error = error as? RepoError {
                let message = error.message.withColor(.red)
                print(message, to: &io.stderr_stream)
                Darwin.exit(EXIT_FAILURE)
            } else {
                throw error
            }
        }
    }
}

extension ParsableCommand where Self: RepoCommand {

    func run() throws {
        try execute(action)
    }

}
