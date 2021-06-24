//
// Statio
// Varun Santhanam
//

import Foundation

extension RepoCommand {

    func tuist(on root: String, bin: String, toolConfig: String, generationOptions: [String], workspace: String, verbose: Bool, action: (() throws -> Void)? = nil) throws {
        let options = generationOptions
            .map { "." + $0 }
            .reduce("") { prev, option in
                prev == "" ? option : prev + ", " + option
            }

        let settings = """
        import ProjectDescription

        let config = Config(
            compatibleXcodeVersions: .list([\"12.5\"]),
            generationOptions: [
                \(options)
            ]
        )
        """

        if verbose {
            write(message: settings)
        }

        let dir = workspace + "/Tuist"
        let path = dir + "/Config.swift"
        _ = try? shell(script: "rm -rf \(dir)", at: root)
        try shell(script: "mkdir \(dir)", at: root, errorMessage: "Couldn't Generate Temporary Directory", verbose: verbose)
        guard let data = settings.data(using: .utf8) else {
            throw CustomRepoError(message: "Couldn't Write Tuist Configuration")
        }
        do {
            try NSData(data: data).write(toFile: root + "/" + path)
        } catch {
            throw CustomRepoError(message: "Couldn't Write Tuist Configuration")
        }
        try shell(script: "\(bin) generate --path \(workspace)", at: root, errorMessage: "Couldn't Generate Project", verbose: verbose)
        try action?()
        _ = try? shell(script: "rm -rf \(dir)", at: root)
    }

}
