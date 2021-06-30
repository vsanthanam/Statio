//
// Statio
// Varun Santhanam
//

import ArgumentParser
import Foundation
import ShellOut
import Yams

/// Lint command
struct LintCommand: ParsableCommand, RepoCommand {

    // MARK: - API

    enum LintCommandError: Error, RepoError {
        case noSwiftVersion
        case lintExecutionFailed
        case lintFailed(warnings: Int, errors: Int, afterFix: Bool)

        var message: String {
            switch self {
            case .noSwiftVersion:
                return "No swift version in arguments or configuration!"
            case .lintExecutionFailed:
                return "Lint execution failed!"
            case let .lintFailed(warnings, errors, afterFix):
                let warningText = warnings == 1 ? "warning" : "warnings"
                let errorText = errors == 1 ? "error" : "errors"
                if afterFix {
                    return "Found \(warnings) \(warningText), \(errors) \(errorText) after fixing"
                } else {
                    return "Found \(warnings) \(warningText), \(errors) \(errorText)"
                }
            }
        }
    }

    @Argument(help: "File to lint")
    var input: String?

    @Option(name: .long, help: "Location of the score five repo")
    var repoRoot: String = FileManager.default.currentDirectoryPath

    @Option(name: .long, help: "Location of the configuration file")
    var toolConfiguration: String = ".repo-config"

    @Option(name: .long, help: "Swift Version")
    var swiftVersion: String?

    @Option(name: .long, help: "Excluded directories")
    var excludeDirs: [String] = []

    @Option(name: .long, help: "Disabled swiftlint rules")
    var disabledLintRules: [String] = []

    @Option(name: .long, help: "Enabled swiftlint rules")
    var enabledLintRules: [String] = []

    @Option(name: .long, help: "Disabled swiftformat rules")
    var disabledFormatRules: [String] = []

    @Option(name: .long, help: "Enabled swiftformat rules")
    var enabledFormatRules: [String] = []

    @Flag(name: .long, help: "Display verbose logging")
    var trace: Bool = false

    @Flag(name: .long, help: "Fix errors where able")
    var autofix: Bool = false

    @Flag(name: .long, help: "For internal use by arcanist. Do not use.")
    var arclint: Bool = false

    // MARK: - ParsableCommand

    static let configuration: CommandConfiguration = .init(commandName: "lint",
                                                           abstract: "Lint `.swift` files",
                                                           version: "2.0")

    // MARK: - RepoCommand

    func action() throws {
        let configuration = try fetchConfiguration(on: repoRoot, location: toolConfiguration)
        let excludeDirs = self.excludeDirs + (configuration?.lint.excludeDirs ?? [])
        let swiftVersion = self.swiftVersion ?? configuration?.lint.swiftformat.swiftVersion
        let disabledLintRules = self.disabledLintRules + (configuration?.lint.swiftlint.disabledRules ?? [])
        let enabledLintRules = self.enabledLintRules + (configuration?.lint.swiftlint.optInRules ?? [])
        let disabledFormatRules = self.disabledFormatRules + (configuration?.lint.swiftformat.disableRules ?? [])
        let enabledFormatRules = self.enabledFormatRules + (configuration?.lint.swiftformat.enableRules ?? [])

        guard let version = swiftVersion else {
            throw LintCommandError.noSwiftVersion
        }

        wipeConfig()

        if autofix, (!arclint) {
            try runSwiftLint(with: configuration,
                             enabledRules: enabledLintRules,
                             disabledRules: disabledLintRules,
                             excludeDirs: excludeDirs,
                             fix: true)
            try runSwiftFormat(with: configuration,
                               enabledRules: enabledFormatRules,
                               disabledRules: disabledFormatRules,
                               swiftVersion: version,
                               excludeDirs: excludeDirs,
                               fix: true)
            wipeConfig()
        }

        let lintResults = try runSwiftLint(with: configuration,
                                           enabledRules: enabledLintRules,
                                           disabledRules: disabledLintRules,
                                           excludeDirs: excludeDirs,
                                           fix: false)
        let formatResults = try runSwiftFormat(with: configuration,
                                               enabledRules: enabledFormatRules,
                                               disabledRules: disabledFormatRules,
                                               swiftVersion: version,
                                               excludeDirs: excludeDirs,
                                               fix: false)

        let results = (lintResults + formatResults).sorted { lhs, rhs in
            guard lhs.file != rhs.file else {
                guard lhs.line != rhs.line else {
                    return lhs.col < rhs.col
                }
                return lhs.line < rhs.line
            }
            return lhs.file < rhs.file
        }

        for result in results {
            if arclint {
                let formatted = "\(result.level.rawValue):\(result.line):\(result.col):\(result.message):\(result.source.rawValue)"
                write(message: formatted)
            } else {
                switch result.level {
                case .warning, .autofix:
                    warn(message: result.description, withColor: .yellow)
                case .error:
                    warn(message: result.description, withColor: .red)
                }
            }
        }

        wipeConfig()

        if arclint {
            complete(with: nil)
            return
        }

        if !results.isEmpty {
            let warnings = results.filter { $0.level == .warning }.count
            let errors = results.filter { $0.level == .error }.count
            throw LintCommandError.lintFailed(warnings: warnings, errors: errors, afterFix: autofix)
        } else {
            if autofix {
                complete(with: "No errors found after fixing! 🍻")
            } else {
                complete(with: "No errors found! 🍻")
            }
        }
    }

    // MARK: - Private

    private func wipeConfig() {
        _ = try? shellOut(to: "rm .swiftlint.yml", at: repoRoot)
        _ = try? shellOut(to: "rm .swiftformat", at: repoRoot)
    }

    @discardableResult
    private func runSwiftLint(with configuration: ToolConfiguration?, enabledRules: [String], disabledRules: [String], excludeDirs: [String], fix: Bool) throws -> [LintResult] {
        struct SwiftLintConfig: Codable {
            var excluded: [String] = []
            var disabled_rules: [String] = []
            var custom_rules: [String: SwiftLintCustomRegexRule] = [:]
        }

        struct SwiftLintCustomRegexRule: Codable {
            var name: String
            var regex: String
            var message: String
            var level: LintResult.Level
            let excluded: String
        }

        var config = SwiftLintConfig()
        let exclude = (excludeDirs + [configuration?.vendorCodePath, configuration?.diGraphPath] + (configuration?.mockolo.destinations ?? []))
            .compactMap { $0 }
            .map { repoRoot + "/" + $0 }
        config.excluded = exclude
        config.disabled_rules = disabledRules
        for rule in (configuration?.lint.swiftlint.warnings ?? []) {
            let customRule = SwiftLintCustomRegexRule(name: rule.name, regex: rule.regex, message: rule.message, level: .warning, excluded: "(^.*tools.*$)")
            config.custom_rules[rule.name] = customRule
        }
        for rule in (configuration?.lint.swiftlint.errors ?? []) {
            let customRule = SwiftLintCustomRegexRule(name: rule.name, regex: rule.regex, message: rule.message, level: .error, excluded: "(^.*tools.*$)")
            config.custom_rules[rule.name] = customRule
        }
        let encoder = YAMLEncoder()
        let yaml = try encoder.encode(config)
        if trace {
            write(message: "SwifLint Configuration")
            write(message: yaml)
        }
        guard let data = yaml.data(using: .utf8) else {
            throw CustomRepoError(message: "Couldn't write swiftlint configuration")
        }
        do {
            try NSData(data: data).write(toFile: repoRoot + "/" + ".swiftlint.yml")
        } catch {
            throw CustomRepoError(message: "Couldn't write swiftlint configuration")
        }
        var command = "bin/swiftlint/swiftlint"
        if fix {
            command = [command, "--path", (input ?? repoRoot), "--fix", "--strict"].joined(separator: " ")
        } else {
            command = [command, "--path", (input ?? repoRoot), "--strict"].joined(separator: " ")
        }
        if trace {
            write(message: "\n" + command + "\n")
        }
        do {
            try shellOut(to: command, at: repoRoot)
            return []
        } catch {
            guard let error = error as? ShellOutError else {
                throw LintCommandError.lintExecutionFailed
            }
            var output = [LintResult]()
            error.output
                .split(separator: "\n")
                .filter { $0.hasPrefix("/") }
                .map { output -> LintResult in
                    .fromOutput(.init(output), source: .swiftlint)
                }
                .forEach { line in
                    output.append(line)
                }
            return output
        }
    }

    @discardableResult
    private func runSwiftFormat(with configuration: ToolConfiguration?, enabledRules: [String], disabledRules: [String], swiftVersion: String, excludeDirs: [String], fix: Bool) throws -> [LintResult] {
        var configComponents: [String] = .init()
        if !disabledRules.isEmpty {
            let disable = "--disable" + " " + disabledRules.joined(separator: ",")
            configComponents.append(disable)

        }
        if !enabledRules.isEmpty {
            let enable = "--enable" + " " + enabledRules.joined(separator: ",")
            configComponents.append(enable)
        }

        let exclude = ([configuration?.vendorCodePath, configuration?.diGraphPath] + (configuration?.mockolo.destinations ?? []) + excludeDirs).compactMap { $0 }

        exclude
            .forEach { exclude in
                let component = "--exclude" + " " + exclude
                configComponents.append(component)
            }

        configComponents.append("--swiftversion \(swiftVersion)")

        let header = """
        //
        // Statio
        // Varun Santhanam
        //
        """
        let headerCommand = "--header \"\(header)\""
        let swiftformat = configComponents.joined(separator: "\n")
        guard let data = swiftformat.data(using: .utf8) else {
            throw CustomRepoError(message: "Couldn't write swiftformat config!")
        }
        do {
            try NSData(data: data).write(toFile: repoRoot + "/" + ".swiftformat")
        } catch {
            throw CustomRepoError(message: "Couldn't write swiftformat config!")
        }
        let configToUse = try shellOut(to: .readFile(at: ".swiftformat"), at: repoRoot)
        if trace, !arclint {
            write(message: "SwiftFormat config:")
            write(message: configToUse)
        }
        let command: String
        if fix {
            command = ["bin/swiftformat/swiftformat", input ?? repoRoot].joined(separator: " ")
        } else {
            command = ["bin/swiftformat/swiftformat", "--lint", input ?? repoRoot, headerCommand].joined(separator: " ")
        }
        if trace, !arclint {
            write(message: "\n" + command + "\n")
        }
        do {
            try shellOut(to: command, at: repoRoot)
            return []
        } catch {
            guard let error = error as? ShellOutError else {
                throw LintCommandError.lintExecutionFailed
            }
            var output = [LintResult]()
            error.message
                .split(separator: "\n")
                .filter { $0.hasPrefix("/") }
                .map { output -> LintResult in
                    .fromOutput(.init(output), source: .swiftformat)
                }
                .forEach { line in
                    output.append(line)
                }
            return output
        }
    }
}

struct LintResult: Codable, CustomStringConvertible {

    enum Source: String, Codable {
        case swiftlint
        case swiftformat
    }

    enum Level: String, Codable {
        case warning
        case error
        case autofix
    }

    var message: String
    var file: String
    var line: Int
    var col: Int
    var level: Level
    var source: Source

    var description: String {
        "[\(level.rawValue)] \(file) at line \(line):\(col) — \(message)"
    }

    static func fromOutput(_ output: String, source: Source) -> LintResult {
        let comps = output.split(separator: ":")
        let file = comps[0]
        let line = Int(comps[1])!
        let col = Int(comps[2])!
        let level = Level(rawValue: String(comps[3].dropFirst()))!
        let message = comps[4 ..< comps.count].joined(separator: " | ")
        return .init(message: .init(message),
                     file: String(file),
                     line: line,
                     col: col,
                     level: level,
                     source: source)
    }
}
