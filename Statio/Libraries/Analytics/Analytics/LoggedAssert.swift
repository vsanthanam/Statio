//
// Statio
// Varun Santhanam
//

import Foundation
import Logging

public protocol FailureKey: Equatable {
    var key: String { get }
}

public func loggedAssert<T>(_ condition: Bool, _ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, column: UInt = #column) where T: FailureKey {
    if !condition {
        AnalyticsManager.shared.logAssertError(key: key.key.expandedKey, file: file, function: function, line: line, column: column)
    }
    assert(condition, message, file: file, line: line)
}

public func loggedAssertionFailure<T>(_ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, column: UInt = #column) where T: FailureKey {
    AnalyticsManager.shared.logAssertError(key: key.key.expandedKey, file: file, function: function, line: line, column: column)
    assertionFailure(message, file: file, line: line)
}

public func loggedPrecondition<T>(_ condition: Bool, _ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, column: UInt = #column) where T: FailureKey {
    if !condition {
        AnalyticsManager.shared.logFatalError(key: key.key.expandedKey, file: file, function: function, line: line, column: column)
    }
    precondition(condition, message, file: file, line: line)
}

public func loggedFatalError<T>(_ message: String, key: T, file: StaticString = #file, function: StaticString = #function, line: UInt = #line, column: UInt = #column) -> Never where T: FailureKey {
    AnalyticsManager.shared.logFatalError(key: key.key.expandedKey, file: file, function: function, line: line, column: column)
    fatalError(message, file: file, line: line)
}
