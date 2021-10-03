//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol BatteryMonitorWorking: Working {}

final class BatteryMonitorWorker: Worker, BatteryMonitorWorking {

    // MARK: - Initializers

    init(batteryProvider: BatteryProviding,
         mutableBatteryLevelStream: MutableBatteryLevelStreaming,
         mutableBatteryStateStream: MutableBatteryStateStreaming) {
        self.batteryProvider = batteryProvider
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

    private let batteryProvider: BatteryProviding
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
            .map { [batteryProvider] _ in
                batteryProvider.level
            }
            .prepend(batteryProvider.level)
            .removeDuplicates()
            .sink { [mutableBatteryLevelStream] level in
                mutableBatteryLevelStream.update(level: level)
            }
            .cancelOnStop(worker: self)
    }

    private func startObservingBatteryState() {
        UIDevice.batteryStateDidChangeNotification.asPublisher()
            .map { [batteryProvider] _ in
                batteryProvider.state
            }
            .prepend(batteryProvider.state)
            .removeDuplicates()
            .sink { [mutableBatteryStateStream] state in
                mutableBatteryStateStream.update(batteryState: state)
            }
            .cancelOnStop(worker: self)

    }

}
