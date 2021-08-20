//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import StatioKit

/// @mockable
protocol BatteryPresentable: BatteryViewControllable {
    var listener: BatteryPresentableListener? { get set }
    func update(level: Battery.Level)
    func update(state: Battery.State)
}

/// @mockable
protocol BatteryListener: AnyObject {
    func batteryDidClose()
}

final class BatteryInteractor: PresentableInteractor<BatteryPresentable>, BatteryInteractable, BatteryPresentableListener {

    // MARK: - Initializers

    init(presenter: BatteryPresentable,
         batteryMonitor: BatteryMonitoring,
         batteryLevelStream: BatteryLevelStreaming,
         batteryStateStream: BatteryStateStreaming) {
        self.batteryMonitor = batteryMonitor
        self.batteryLevelStream = batteryLevelStream
        self.batteryStateStream = batteryStateStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: BatteryListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingBatteryLevel()
        startObservingBatteryState()
        batteryMonitor.start(on: self)
    }

    // MARK: - BatteryPresentableListener

    func didTapBack() {
        listener?.batteryDidClose()
    }

    // MARK: - Private

    private let batteryMonitor: BatteryMonitoring
    private let batteryLevelStream: BatteryLevelStreaming
    private let batteryStateStream: BatteryStateStreaming

    private func startObservingBatteryLevel() {
        batteryLevelStream.batteryLevel
            .removeDuplicates()
            .sink { [presenter] level in
                presenter.update(level: level)
            }
            .cancelOnDeactivate(interactor: self)
    }

    private func startObservingBatteryState() {
        batteryStateStream.batteryState
            .removeDuplicates()
            .sink { [presenter] state in
                presenter.update(state: state)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
