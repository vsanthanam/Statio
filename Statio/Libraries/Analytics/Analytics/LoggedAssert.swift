//
// Statio
// Varun Santhanam
//

import Foundation
import Logging

public protocol FailureKey: Equatable {
    var key: String { get }
}

public func loggedAssert<T>(_ condition: Bool, _ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) where T: FailureKey {
    if !condition {
        AnalyticsManager.shared.logAssertError(key: key.key.expandedKey, file: file, function: function, line: line)
    }
    assert(condition, message, file: file, line: line)
}

public func loggedAssertionFailure<T>(_ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) where T: FailureKey {
    AnalyticsManager.shared.logAssertError(key: key.key.expandedKey, file: file, function: function, line: line)
    assertionFailure(message, file: file, line: line)
}

public func loggedPrecondition<T>(_ condition: Bool, _ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) where T: FailureKey {
    if !condition {
        AnalyticsManager.shared.logFatalError(key: key.key.expandedKey, file: file, function: function, line: line)
    }
    precondition(condition, message, file: file, line: line)
}

public func loggedFatalError<T>(_ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Never where T: FailureKey {
    AnalyticsManager.shared.logFatalError(key: key.key.expandedKey, file: file, function: function, line: line)
    fatalError(message, file: file, line: line)
}
