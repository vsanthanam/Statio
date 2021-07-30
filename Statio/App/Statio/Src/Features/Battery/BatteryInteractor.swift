//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs

/// @mockable
protocol BatteryPresentable: BatteryViewControllable {
    var listener: BatteryPresentableListener? { get set }
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
}
