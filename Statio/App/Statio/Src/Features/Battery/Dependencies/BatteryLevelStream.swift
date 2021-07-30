//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @mockable
protocol BatteryLevelStreaming: AnyObject {
    var batteryLevel: AnyPublisher<Double, Never> { get }
}

/// @mockable
protocol MutableBatteryLevelStreaming: BatteryLevelStreaming {
    func update(level: Double)
}

final class BatteryLevelStream: MutableBatteryLevelStreaming {

    // MARK: - BatteryLevelStreaming

    var batteryLevel: AnyPublisher<Double, Never> {
        subject
            .eraseToAnyPublisher()
    }

    // MARK: - MutableBatteryLevelStreaming

    func update(level: Double) {
        subject.send(level)
    }

    // MARK: - Private

    private let subject = ReplaySubject<Double, Never>(bufferSize: 1)

}
