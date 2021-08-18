//
// Statio
// Varun Santhanam
//

import Foundation

extension RepoCommand {

    func tuist(on root: String, bin: String, toolConfig: String, workspace: String, verbose: Bool, action: (() throws -> Void)? = nil) throws {
        try shell(script: "\(bin) generate --path \(workspace)", at: root, errorMessage: "Couldn't Generate Project", verbose: verbose)
        try action?()
    }

}
