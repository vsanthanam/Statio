//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @mockable
protocol BatteryStateStreaming: AnyObject {
    var batteryState: AnyPublisher<BatteryState, Never> { get }
}

/// @mockable
protocol MutableBatteryStateStreaming: BatteryStateStreaming {
    func update(batteryState: BatteryState)
}

final class BatteryStateStream: MutableBatteryStateStreaming {

    // MARK: - BatteryStateStreaming

    var batteryState: AnyPublisher<BatteryState, Never> {
        subject
            .eraseToAnyPublisher()
    }

    // MARK: - MutableBatteryStateStreaming

    func update(batteryState: BatteryState) {
        subject.send(batteryState)
    }

    // MARK: - Private

    private let subject = ReplaySubject<BatteryState, Never>(bufferSize: 1)

}
