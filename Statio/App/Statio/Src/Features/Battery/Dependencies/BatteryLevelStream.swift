//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation
import StatioKit

/// @mockable
protocol BatteryLevelStreaming: AnyObject {
    var batteryLevel: AnyPublisher<Battery.Level, Never> { get }
}

/// @mockable
protocol MutableBatteryLevelStreaming: BatteryLevelStreaming {
    func update(level: Battery.Level)
}

final class BatteryLevelStream: MutableBatteryLevelStreaming {

    // MARK: - BatteryLevelStreaming

    var batteryLevel: AnyPublisher<Battery.Level, Never> {
        subject
            .eraseToAnyPublisher()
    }

    // MARK: - MutableBatteryLevelStreaming

    func update(level: Battery.Level) {
        subject.send(level)
    }

    // MARK: - Private

    private let subject = ReplaySubject<Battery.Level, Never>(bufferSize: 1)

}
