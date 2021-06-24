//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

/// A protocol that defines the public interface of an `Interactor` available to other classes
///
/// @mockable
public protocol Interactable: WorkerScope {

    /// Activate the interactor
    /// - Note: You probably shouldn't invoke this method directly.
    ///         It's automatically invoked when the interactor is attached to its parent/
    func activate()

    /// Deactivate the interactor
    /// - Note: You probably shouldn't invoke this method directly.
    ///         It's automatically invoked when the interactor is detached from its parent.
    func deactivate()
}

/// # Interactor
///
/// An `Interactor`  is node in the application's state tree.
/// It is activated by its parent, and is responsible for activating its children.
///
/// @mockable
open class Interactor: Interactable {

    // MARK: - Initializers

    /// Initialize an `Interactor`
    public init() {}

    // MARK: - Abstract Methods

    /// Abstract method invoked just after this interactor activates
    /// Override this method to start any business logic specific to this scope.
    open func didBecomeActive() {}

    /// Abstract method invoked just before this interactor deactivates
    /// Override this method to stop any business logic or reset state specific to this scope.
    open func willResignActive() {}

    // MARK: - API

    /// The active children of this interactor..
    /// You can add or remove children using the `attach(interactor:)` and `detach(interactor:)` instance methods
    /// Children are activate when they are attached and deactivated when they are attached.
    public private(set) final var children: [Interactable] = []

    /// Attach a child to the interactor
    /// - Parameter child: The child to attach.
    /// - Note: This method will cause a runtime failure if the provided child has already been attached, or is already active.
    public final func attach(child: Interactable) {
        assert(isActive, "You cannot attach children while the interactor is inactive!")
        assert(!child.isActive, "You cannot attach a child that is already active!")
        guard !children.contains(child) else {
            return
        }
        children.append(child)
        child.activate()
    }

    /// Detach an already attached child from the interactor
    /// - Parameter child: The child to detach
    /// - Note: This method will cause a runtime failure if the provided child has already been detached, or has already ben deactivated.
    public final func detach(child: Interactable) {
        assert(child.isActive, "You cannot detach a child that isn't active!")
        guard let index = children.firstIndex(where: { e in e as AnyObject === child as AnyObject }) else {
            return
        }
        children.remove(at: index)
        child.deactivate()
    }

    // MARK: - WorkerScope

    @Published
    public private(set) final var isActive: Bool = false

    public final var isActiveStream: AnyPublisher<Bool, Never> {
        $isActive
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Interactable

    public final func activate() {
        guard !isActive else {
            return
        }
        storage = Set<AnyCancellable>()
        isActive = true
        children.forEach { $0.activate() }
        didBecomeActive()
    }

    public final func deactivate() {
        guard isActive else {
            return
        }
        willResignActive()
        children.forEach { $0.deactivate() }
        storage?.forEach { cancellable in cancellable.cancel() }
        storage = nil
        isActive = false
    }

    // MARK: - Private

    private var storage: Set<AnyCancellable>?

    fileprivate func store(cancellable: Cancellable) -> Bool {
        guard storage != nil else {
            return false
        }
        cancellable.store(in: &storage!)
        return true
    }

    // MARK: - Deinit

    deinit {
        if isActive {
            deactivate()
        }
        children.forEach { child in detach(child: child) }
    }
}

public extension Publisher where Failure == Never {

    func confine(to interactor: Interactable) -> AnyPublisher<Output, Failure> {
        combineLatest(interactor.isActiveStream) { element, isActive in
            (element, isActive)
        }
        .filter { _, isActive in
            isActive
        }
        .map { element, _ in
            element
        }
        .eraseToAnyPublisher()
    }

}

public extension Cancellable {

    @discardableResult
    func cancelOnDeactivate(interactor: Interactor) -> Cancellable {
        if !interactor.store(cancellable: self) {
            cancel()
        }
        return self
    }

}

public extension Array where Element == Interactable {
    func contains(_ element: Element) -> Bool {
        contains { $0 === element }
    }
}
