//
// Aro
// Varun Santhanam
//

import Foundation
import ShellOut

extension RepoCommand {

    // MARK: - API

    func write(message: String, withColor color: Color? = nil) {
        if let color = color {
            print(message.withColor(color), to: &io.stdout_stream)
        } else {
            print(message, to: &io.stdout_stream)
        }
    }

    func warn(message: String, withColor color: Color? = nil) {
        if let color = color {
            print(message.withColor(color), to: &io.stderr_stream)
        } else {
            print(message, to: &io.stderr_stream)
        }
    }

    func complete(with message: String? = "Success! 🍻", color: Color = .green) {
        if let message = message {
            print(message.withColor(color), to: &io.stdout_stream)
        }
    }

    @discardableResult
    func shell(_ command: ShellOutCommand, at path: String = ".", errorMessage: String? = nil, verbose: Bool = false) throws -> String {
        do {
            if verbose {
                write(message: "\n" + command.string + "\n")
            }
            return try shellOut(to: command,
                                at: path,
                                outputHandle: verbose ? io.stdout : nil,
                                errorHandle: verbose ? io.stderr : nil)
        } catch {
            throw CustomRepoError(message: errorMessage ?? "Command Failed!")
        }
    }

    @discardableResult
    func shell(script: String, at path: String = ".", errorMessage: String? = nil, verbose: Bool = false) throws -> String {
        try shell(.init(string: script),
                  at: path,
                  errorMessage: errorMessage,
                  verbose: verbose)
    }
}

enum io {

    static var stderr_stream = StandardError()

    static var stdout_stream = StandardOut()

    static let stderr = FileHandle.standardError

    static let stdout = FileHandle.standardOutput

    struct StandardError: TextOutputStream {
        func write(_ string: String) {
            guard let data = string.data(using: .utf8) else {
                return // encoding failure
            }
            stderr.write(data)
        }
    }

    struct StandardOut: TextOutputStream {
        func write(_ string: String) {
            guard let data = string.data(using: .utf8) else {
                return // encoding failure
            }
            stdout.write(data)
        }
    }
}

enum Color: Int {
    case red = 31
    case green = 32
    case yellow = 33
}

extension String {
    func withColor(_ color: Color) -> String {
        "\u{1B}[\(color.rawValue)m\(self)\u{1B}[0m"
    }
}
