//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol BatteryMonitoring: Working {}

final class BatteryMonitor: Worker, BatteryMonitoring {

    // MARK: - Initializers

    init(mutableBatteryLevelStream: MutableBatteryLevelStreaming,
         mutableBatteryStateStream: MutableBatteryStateStreaming) {
        self.mutableBatteryLevelStream = mutableBatteryLevelStream
        self.mutableBatteryStateStream = mutableBatteryStateStream
        super.init()
    }

    override func didStart(on scope: Workable) {
        super.didStart(on: scope)
        enableSystemBatteryMonitor()
        startObservingBatteryLevel()
        startObservingBatteryState()
    }

    override func didStop() {
        disableSystemBatteryMonitor()
        super.didStop()
    }

    // MARK: - Private

    private let mutableBatteryLevelStream: MutableBatteryLevelStreaming
    private let mutableBatteryStateStream: MutableBatteryStateStreaming

    private func enableSystemBatteryMonitor() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    private func disableSystemBatteryMonitor() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }

    private func startObservingBatteryLevel() {
        UIDevice.batteryLevelDidChangeNotification.asPublisher()
            .map { _ in
                Double(UIDevice.current.batteryLevel)
            }
            .prepend(.init(UIDevice.current.batteryLevel))
            .removeDuplicates()
            .sink { [mutableBatteryLevelStream] level in
                mutableBatteryLevelStream.update(level: level)
            }
            .cancelOnStop(worker: self)
    }

    private func startObservingBatteryState() {
        UIDevice.batteryLevelDidChangeNotification.asPublisher()
            .map { _ in
                UIDevice.current.batteryState
            }
            .prepend(UIDevice.current.batteryState)
            .map(\.asState)
            .removeDuplicates()
            .sink { [mutableBatteryStateStream] state in
                mutableBatteryStateStream.update(batteryState: state)
            }
            .cancelOnStop(worker: self)

    }

}

private extension UIDevice.BatteryState {
    var asState: BatteryState {
        switch self {
        case .unknown:
            return .unknown
        case .charging:
            return .charging
        case .unplugged:
            return .discharging
        case .full:
            return .full
        @unknown default:
            return .unknown
        }
    }
}
