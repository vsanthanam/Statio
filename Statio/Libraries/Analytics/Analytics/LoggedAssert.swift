//
// Aro
// Varun Santhanam
//

import Foundation
import Logging

public func loggedAssert(_ condition: Bool, _ message: String, key: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    if !condition {
        AnalyticsManager.shared.logAssertError(key: key, file: file, function: function, line: line)
    }
    assert(condition, message, file: file, line: line)
}

public func loggedAssertionFailure(_ message: String, key: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    AnalyticsManager.shared.logAssertError(key: key, file: file, function: function, line: line)
    assertionFailure(message, file: file, line: line)
}

public func loggedPrecondition(_ condition: Bool, _ message: String, key: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    if !condition {
        AnalyticsManager.shared.logFatalError(key: key, file: file, function: function, line: line)
    }
    precondition(condition, message, file: file, line: line)
}

public func loggedFatalError(_ message: String, key: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Never {
    AnalyticsManager.shared.logFatalError(key: key, file: file, function: function, line: line)
    fatalError(message, file: file, line: line)
}
