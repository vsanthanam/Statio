//
// Statio
// Varun Santhanam
//

import Combine
import CombineExt
import Foundation

/// @CreateMock
protocol AppStateProviding: AnyObject {
    var state: AnyPublisher<AppState, Never> { get }
}

/// @CreateMock
protocol AppStateManaging: AppStateProviding {
    func update(state: AppState)
}

final class AppStateManager: AppStateManaging {

    // MARK: - AppStateProviding

    var state: AnyPublisher<AppState, Never> {
        subject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - AppStateManaging

    func update(state: AppState) {
        subject.send(state)
    }

    // MARK: - Private

    private let subject = ReplaySubject<AppState, Never>(bufferSize: 1)
}
