//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation

enum AnalyticsEvent: String, Event, Equatable, Hashable, CustomStringConvertible {

    case root_become_active
    case main_vc_impression
    case monitor_vc_impression
    case settings_vc_impression

    // MARK: - Event

    var key: String { "event_" + rawValue }

    // MARK: - Equatable

    static func == (lhs: AnalyticsEvent, rhs: AnalyticsEvent) -> Bool {
        lhs.key == rhs.key
    }

    // MARK: - CustomStringConvertible

    var description: String {
        key
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

enum AnalyticsTrace: String, Trace, Equatable, Hashable, CustomStringConvertible {

    case app_launch

    // MARK: - Trace

    var key: String { "trace_" + rawValue }

    // MARK: - Equatable

    static func == (lhs: AnalyticsTrace, rhs: AnalyticsTrace) -> Bool {
        lhs.key == rhs.key
    }

    // MARK: - CustomStringConvertible

    var description: String {
        key
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}
