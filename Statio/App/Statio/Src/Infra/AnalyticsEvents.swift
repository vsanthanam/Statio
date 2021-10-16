//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation

enum AnalyticsEvent: String, Event, Equatable, Hashable, CustomStringConvertible {

    case root_become_active
    case main_vc_impression
    case settings_vc_impression
    case reporter_vc_impression
    case monitor_vc_impression
    case monitor_list_vc_impression
    case device_identity_vc_impression
    case device_identity_vc_dismiss
    case memory_vc_impression
    case memory_vc_dismiss
    case battery_vc_impression
    case battery_vc_dismiss
    case disk_vc_impression
    case disk_vc_dismiss
    case processor_vc_impression
    case processor_vc_dismiss
    case cellular_vc_impression
    case cellular_vc_dismiss
    case wifi_vc_impression
    case wifi_vc_dismiss
    case accelerometer_vc_impression
    case accelerometer_vc_dismiss
    case gyroscope_vc_impression
    case gyroscope_vc_dismiss
    case magnometer_vc_impression
    case magnometer_vc_dismiss

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
