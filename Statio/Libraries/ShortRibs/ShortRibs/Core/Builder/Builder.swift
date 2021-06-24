//
// Statio
// Varun Santhanam
//

import Foundation

/// @CreateMock
public protocol Buildable: AnyObject {}

open class Builder<Dependency>: Buildable {

    public init(dependency: Dependency) {
        self.dependency = dependency
    }

    public let dependency: Dependency

}
