//
// Aro
// Varun Santhanam
//

import Countly
import Foundation
import Logging
import os.log

public protocol Event: Equatable {
    var key: String { get }
}

public protocol Trace: Equatable {
    var key: String { get }
}

/// @mockable
public protocol AnalyticsManaging: AnyObject {
    func send<T>(event: T, segmentation: [String: String]?, count: UInt, sum: Double, duration: TimeInterval) where T: Analytics.Event
    func start<T>(trace: T) where T: Analytics.Trace
    func stop<T>(trace: T, segmentation: [String: String]?) where T: Analytics.Trace
    func cancel<T>(trace: T) where T: Analytics.Trace
}

public extension AnalyticsManaging {
    func send<T>(event: T,
                 segmentation: [String: String]? = nil,
                 count: UInt = 1,
                 sum: Double = 0.0,
                 duration: TimeInterval = 0.0) where T: Event {
        send(event: event, segmentation: segmentation, count: count, sum: sum, duration: duration)
    }

    func stop<T>(trace: T, segmentation: [String: String]? = nil) where T: Trace {
        stop(trace: trace, segmentation: segmentation)
    }
}

public final class AnalyticsManager: AnalyticsManaging {

    // MARK: - API

    public struct Configuration: Codable {
        public let appKey: String?
        public let host: String?
    }

    /// The shared instance
    public static let shared: AnalyticsManager = .init()

    /// Whether or not analytics events are accepted
    public private(set) var isStarted: Bool = false

    /// Event Prefix
    public var eventPrefix: String = ""

    /// Start the analytics manager
    /// - Parameter config: The configuration, used to determine where to send events
    public func startAnalytics(with configuration: Configuration) {
        #if targetEnvironment(simulator) || DEBUG
            if AnalyticsEnvironment[.sendInDebug] == true {
                validateAndStart(configuration)
            } else {
                startAnonymously()
            }
        #else
            validateAndStart(configuration)
        #endif
    }

    /// Stop the analytics manager
    public func stopAnalytics() {
        isStarted = false
    }

    // MARK: - AnalyticsManaging

    public func send<T>(event: T,
                        segmentation: [String: String]?,
                        count: UInt,
                        sum: Double,
                        duration: TimeInterval) where T: Event {
        send(key: event.key,
             segmentation: segmentation,
             count: count,
             sum: sum,
             duration: duration)
    }
    
    

    public func start<T>(trace: T) where T: Trace {
        let key = (eventPrefix + trace.key).expandedKey
        guard !isAnonymous else {
            os_log("Ignoring start trace: %{public}@", log: .analytics, type: .info, key)
            return
        }
        os_log("Starting trace: %{public}@", log: .analytics, type: .info, key)
        Countly.sharedInstance().startEvent(key)
    }

    public func stop<T>(trace: T, segmentation: [String: String]?) where T: Trace {
        let key = (eventPrefix + trace.key).expandedKey
        guard !isAnonymous else {
            os_log("Ignoring stop trace: %{public}@", log: .analytics, type: .info, key)
            return
        }
        os_log("Stopping trace: %{public}@", log: .analytics, type: .info, key)
        Countly.sharedInstance().endEvent(key, segmentation: segmentation, count: 1, sum: 0.0)
    }

    public func cancel<T>(trace: T) where T: Trace {
        let key = (eventPrefix + trace.key).expandedKey
        guard !isAnonymous else {
            os_log("Ignoring cancel trace: %{public}@", log: .analytics, type: .info, key)
            return
        }
        os_log("Canceling trace: %{public}@", log: .analytics, type: .info, key)
        Countly.sharedInstance().cancelEvent(key)
    }

    // MARK: - Private

    private var isAnonymous = false

    private var isTesting: Bool {
        #if DEBUG
            ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
            false
        #endif
    }

    internal func logAssertError(key: String, file: StaticString, function: StaticString, line: UInt) {
        let meta = ["key": "\(key)",
                    "file": "\(file)",
                    "function": "\(function)",
                    "line": String(line)]
        send(key: "failure_\(key)", segmentation: meta)
    }

    internal func logFatalError(key: String, file: StaticString, function: StaticString, line: UInt) {
        let meta = ["key": "\(key)",
                    "file": "\(file)",
                    "function": "\(function)",
                    "line": String(line)]
        send(key: "fatal_\(key)", segmentation: meta)
    }

    private func send(key: String,
                      segmentation: [String: String]? = nil,
                      count: UInt = 1,
                      sum: Double = 0.0,
                      duration: TimeInterval = 0.0) {
        let key = (eventPrefix + key).expandedKey
        
        guard isStarted else {
            assertionFailure("Attempt to log event \(key) without active analytics manager!")
            return
        }

        guard !isAnonymous else {
            os_log("Ignoring event: %{public}@", log: .analytics, type: .info, key)
            return
        }
        os_log("Sending event: %{public}@", log: .analytics, type: .info, key)
        Countly.sharedInstance().recordEvent(key,
                                             segmentation: segmentation,
                                             count: count,
                                             sum: sum,
                                             duration: duration)
    }

    private func validateAndStart(_ configuration: Configuration) {
        guard let appKey = configuration.appKey,
              let host = configuration.host else {
            guard isTesting else {
                fatalError("Empty or invalid analytics configuration! Run `./repo analytics install`")
            }
            startAnonymously()
            return
        }
        let countlyConfig = CountlyConfig()
        countlyConfig.appKey = appKey
        countlyConfig.host = host
        countlyConfig.features = [.crashReporting]
        Countly.sharedInstance().start(with: countlyConfig)
        isStarted = true
    }

    private func startAnonymously() {
        isAnonymous = true
        isStarted = true
    }

}

fileprivate extension String {
    
    var expandedKey: String {
        uncapped.lowercased().split(separator: " ").joined(separator: "_")
    }
    
    private var uncapped: String {
        var newString: String = ""
        let upperCase = CharacterSet.uppercaseLetters
        for scalar in self.unicodeScalars {
            if upperCase.contains(scalar) {
                newString.append(" ")
            }
            let character = Character(scalar)
                newString.append(character)
            }

        return newString
    }

}
