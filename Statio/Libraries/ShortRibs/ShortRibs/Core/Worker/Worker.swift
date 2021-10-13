//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

/// A protocol defining an object that a `Worker` can work on
/// @CreateMock
public protocol Workable: AnyObject {

    /// Whether or not the workable scope is active
    var isActive: Bool { get }

    /// A stream of `isActive`
    var isActiveStream: AnyPublisher<Bool, Never> { get }

}

/// A protocol describing a worker
/// @CreateMock
public protocol Working: AnyObject {

    /// Start the worker
    /// - Parameter workable: The `workable` scope to bind the worker too
    func start(on scope: Workable)

    /// Stop the worker
    func stop()

    /// Whether or not the worker has been started
    var isStarted: Bool { get }

    /// A stream of `isStarted`
    var isStartedStream: AnyPublisher<Bool, Never> { get }
}

open class Worker: Working {

    // MARK: - Initializer

    /// Create a `Worker`
    /// - Note: In subclasses, constructor inject static dependencies.
    public init() {}

    // MARK: - API

    /// Called when the worker starts
    /// - Parameter workable: The workable scope that the worker is bound to
    open func didStart(on scope: Workable) {
        // Optional Abstract Method
    }

    /// Called when the worker stops
    open func didStop() {
        // Optional Abstract Method
    }

    // MARK: - Working

    @Published
    public private(set) final var isStarted: Bool = false

    public final var isStartedStream: AnyPublisher<Bool, Never> {
        $isStarted.eraseToAnyPublisher()
    }

    public final func start(on scope: Workable) {
        guard !isStarted else {
            return
        }

        stop()

        isStarted = true
        bind(to: AnyWeakScope(scope))
    }

    public final func stop() {
        guard isStarted else {
            return
        }

        isStarted = false

        internalStop()
    }

    // MARK: - Internal

    func store(cancellable: Cancellable) -> Bool {
        guard storage != nil else {
            return false
        }
        cancellable.store(in: &storage!)
        return true
    }

    // MARK: - Private

    @AutoCancel
    private var binding: Cancellable?

    private var storage: Set<AnyCancellable>?

    private func bind(to scope: Workable) {
        binding = nil

        binding = scope.isActiveStream
            .sink { [weak self] isActive in
                if isActive {
                    if self?.isStarted == true {
                        self?.internalStart(on: scope)
                    }
                } else {
                    self?.internalStop()
                }
            }
    }

    private func internalStart(on workable: Workable) {
        storage = Set<AnyCancellable>()
        didStart(on: workable)
    }

    private func internalStop() {
        guard let storage = storage else {
            return
        }
        storage.forEach { stream in stream.cancel() }

        didStop()
    }

    deinit {
        stop()
    }

    private final class AnyWeakScope: Workable {

        private weak var workable: Workable?

        var isActive: Bool {
            workable?.isActive ?? false
        }

        var isActiveStream: AnyPublisher<Bool, Never> {
            workable?.isActiveStream ?? Just<Bool>(false).eraseToAnyPublisher()
        }

        init(_ workable: Workable) {
            self.workable = workable
        }

    }

}

public extension Cancellable {

    @discardableResult
    func cancelOnStop(worker: Worker) -> Cancellable {
        if !worker.store(cancellable: self) {
            cancel()
        }
        return self
    }

}
