//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation
import StatioKit

/// @mockable
protocol BatteryStateStreaming: AnyObject {
    var batteryState: AnyPublisher<Battery.State, Never> { get }
}

/// @mockable
protocol MutableBatteryStateStreaming: BatteryStateStreaming {
    func update(batteryState: Battery.State)
}

final class BatteryStateStream: MutableBatteryStateStreaming {

    // MARK: - BatteryStateStreaming

    var batteryState: AnyPublisher<Battery.State, Never> {
        subject
            .eraseToAnyPublisher()
    }

    // MARK: - MutableBatteryStateStreaming

    func update(batteryState: Battery.State) {
        subject.send(batteryState)
    }

    // MARK: - Private

    private let subject = ReplaySubject<Battery.State, Never>(bufferSize: 1)

}
