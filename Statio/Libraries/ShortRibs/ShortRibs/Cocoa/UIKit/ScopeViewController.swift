//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import UIKit

/// @mockable
public protocol ViewControllable: AnyObject {
    var uiviewController: UIViewController { get }
}

open class BaseScopeViewController<T>: UIViewController, ViewControllable where T: ScopeView {

    // MARK: - Initializers

    /// Initialize a `ScopeViewController` with a view builder
    /// - Parameter viewBuilder: The closure used to build the view on `loadView`
    public init(_ viewBuilder: @escaping () -> T) {
        self.viewBuilder = viewBuilder
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - API

    /// `BaseScopeViewController` lifecycle events
    /// Observe `lifecycleStream` to get this info in real time.
    public enum LifecycleEvent {

        /// Fired on `loadView()`
        case loadView

        /// Fired on `viewDidLoad()`
        case viewDidLoad

        /// Fired on `viewWillAppear(_:)`
        case viewWillAppear

        /// Fired on `viewWillLayoutSubviews`
        case viewWillLayoutSubviews

        /// Fired on `viewDidLayoutSubviews`
        case viewDidLayoutSubviews

        /// Fired on `viewDidAppear(_:)`
        case viewDidAppear

        /// Fired on `viewWillDisappear(_:)`
        case viewWillDisappear

        /// Fired on `viewDidDisappear(_:)`
        case viewDidDisappear
    }

    /// The typed, read-only interface for the view managed by this view controller
    public final var specializedView: T {
        unsafeDowncast(view, to: T.self)
    }

    /// The type-erased, read-only interface for the view managed by this view controller
    public var scopeView: some ScopeView {
        specializedView
    }

    /// A `Publisher` to observe lifecycle events
    /// - seeAlso: `BaseScopeViewController.LifecycleEvent`
    public final var lifecycleStream: AnyPublisher<LifecycleEvent, Never> {
        lifecycleSubject
            .compactMap { event in
                event
            }
            .eraseToAnyPublisher()
    }

    /// Confine some closure to a set of lifecycle events
    /// - Parameters:
    ///   - viewEvents: Events
    ///   - once: Whether or not to execute the closure just once
    ///   - closure: Closure to execute
    open func confineTo(viewEvents: [LifecycleEvent] = [.viewDidLoad,
                                                        .viewWillAppear,
                                                        .viewWillDisappear],
                        once: Bool = false,
                        closure: @escaping () -> Void) {
        confineTo(viewEvents: viewEvents,
                  value: (),
                  once: once,
                  closure: closure)
    }

    /// Confine some closure to a set of lifecycle events
    /// - Parameters:
    ///   - viewEvents: Events
    ///   - value: Value to feed into closure
    ///   - once: Whether or not to execute the closure just once
    ///   - closure: Closure to execute
    open func confineTo<T>(viewEvents: [LifecycleEvent] = [.viewDidLoad,
                                                           .viewWillAppear,
                                                           .viewWillDisappear],
                           value: T,
                           once: Bool = false,
                           closure: @escaping (T) -> Void) {
        var confined = Just<T>(value)
            .eraseToAnyPublisher()
            .confineTo(viewEvents: viewEvents,
                       ofViewController: self)
        if once {
            confined = confined
                .first()
                .eraseToAnyPublisher()
        }

        confined
            .sink { value in
                closure(value)
            }
            .cancelOnDeinit(self)
    }

    /// Executed within `loadView`, just after `view` has a value.
    /// Override this method instead of overriding `loadView`
    open func onViewLoad() {}

    // MARK: - UIViewController

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't use interface builder 😡")
    }

    override open var view: UIView! {
        get {
            super.view
        }
        set {
            assertionFailure("You cannot assign the `view` of a `ScopeViewController`")
        }
    }

    override public final func loadView() {
        super.view = viewBuilder()
        onViewLoad()
        lifecycleSubject.send(.loadView)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        lifecycleSubject.send(.viewDidLoad)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleSubject.send(.viewWillAppear)
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lifecycleSubject.send(.viewWillLayoutSubviews)
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lifecycleSubject.send(.viewDidLayoutSubviews)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleSubject.send(.viewDidAppear)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleSubject.send(.viewWillDisappear)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleSubject.send(.viewDidDisappear)
    }

    // MARK: - ViewControllable

    public var uiviewController: UIViewController { self }

    // MARK: - Private

    fileprivate func store(cancellable: Cancellable) {
        cancellable.store(in: &storage)
    }

    private var storage = Set<AnyCancellable>()
    private let lifecycleSubject = CurrentValueSubject<LifecycleEvent?, Never>(nil)

    private let viewBuilder: () -> T

    // MARK: - Deinit

    deinit {
        storage.forEach { cancellable in cancellable.cancel() }
        storage.removeAll()
    }
}

open class ScopeViewController: BaseScopeViewController<ScopeView> {
    public init() {
        super.init(ScopeView.init)
    }
}

public extension Cancellable {
    @discardableResult
    func cancelOnDeinit<T>(_ viewController: BaseScopeViewController<T>) -> Cancellable {
        viewController.store(cancellable: self)
        return self
    }
}

public extension Set where Element: Cancellable {
    func cancelOnDeinit<T>(_ viewController: BaseScopeViewController<T>) {
        forEach { cancellable in
            cancellable.cancelOnDeinit(viewController)
        }
    }
}

extension Publisher where Failure == Never {
    func confineTo<T>(viewEvents: [BaseScopeViewController<T>.LifecycleEvent], ofViewController viewController: BaseScopeViewController<T>) -> AnyPublisher<Output, Failure> {
        let withinEventsSetStream = viewController.lifecycleStream.map { viewEvents.contains($0) }
        return withinEventsSetStream
            .combineLatest(self) { withinEventsSet, value in
                (withinEventsSet, value)
            }
            .filter { withinEventsSet, _ in
                withinEventsSet
            }
            .map { _, value in
                value
            }
            .eraseToAnyPublisher()
    }
}
