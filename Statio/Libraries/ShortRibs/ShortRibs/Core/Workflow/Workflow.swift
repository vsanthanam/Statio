//
// Aro
// Varun Santhanam
//

import Combine
import Foundation

enum WorkflowError: Error {
    case completion
}

open class Workflow<ActionableItemType> {

    // MARK: - Initializers

    public init() {}

    // MARK: - Abstract Methods

    open func didComplete() {}

    open func didFork() {}

    open func didReceiveError(_ error: Error) {}

    // MARK: - API

    public final func onStep<NextActionableItemType, NextValueType>(_ onStep: @escaping (ActionableItemType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>) -> Step<ActionableItemType, NextActionableItemType, NextValueType> {
        Step(workflow: self, publisher: subject.first().eraseToAnyPublisher())
            .onStep { (actionableItem: ActionableItemType, _) in
                onStep(actionableItem)
            }
    }

    public final func subscribe(_ actionableItem: ActionableItemType) -> Set<AnyCancellable> {
        guard !compositeCancellable.isEmpty else {
            assertionFailure("Attempt to subscribe to \(self) before it is comitted.")
            return Set<AnyCancellable>()
        }

        subject.send((actionableItem, ()))
        return compositeCancellable
    }

    // MARK: - Private

    private let subject = PassthroughSubject<(ActionableItemType, Void), Error>()

    fileprivate var compositeCancellable = Set<AnyCancellable>()
    private var didInvokeComplete = false

    fileprivate func didCompleteIfNotYet() {
        // Since a workflow may be forked to produce multiple subscribed combinee chains, we should
        // ensure the didComplete method is only invoked once per Workflow instance. See `Step.commit`
        // on why the side-effects must be added at the end of the combine chains.
        guard !didInvokeComplete else {
            return
        }
        didInvokeComplete = true
        didComplete()
    }
}

open class Step<WorkflowActionableItemType, ActionableItemType, ValueType> {

    // MARK: - API

    /// Executes the given closure for this step.
    ///
    /// - parameter onStep: The closure to execute for the `Step`.
    /// - returns: The next step.
    public final func onStep<NextActionableItemType, NextValueType>(_ onStep: @escaping (ActionableItemType, ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error>) -> Step<WorkflowActionableItemType, NextActionableItemType, NextValueType> {
        let confinedNextStep = publisher
            .map { (actionableItem, value) -> AnyPublisher<(Bool, ActionableItemType, ValueType), Error> in
                if let scope = actionableItem as? Interactable {
                    return scope
                        .isActiveStream
                        .map { isActive -> (Bool, ActionableItemType, ValueType) in
                            (isActive, actionableItem, value)
                        }
                        .mapError { _ in
                            WorkflowError.completion
                        }
                        .eraseToAnyPublisher()
                } else {
                    let justSubj = CurrentValueSubject<(Bool, ActionableItemType, ValueType), Error>((true, actionableItem, value))
                    return justSubj.eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .filter { (isActive: Bool, _, _) -> Bool in
                isActive
            }
            .first()
            .map { (_, actionableItem: ActionableItemType, value: ValueType) -> AnyPublisher<(NextActionableItemType, NextValueType), Error> in
                onStep(actionableItem, value)
            }
            .switchToLatest()
            .first()
            .share()
            .eraseToAnyPublisher()

        return Step<WorkflowActionableItemType, NextActionableItemType, NextValueType>(workflow: workflow, publisher: confinedNextStep)
    }

    /// Executes the given closure when the `Step` produces an error.
    ///
    /// - parameter onError: The closure to execute when an error occurs.
    /// - returns: This step.
    public final func onError(_ onError: @escaping ((Error) -> Void)) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType> {
        publisher = publisher
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    onError(error)
                default:
                    break
                }
            })
            .eraseToAnyPublisher()
        return self
    }

    /// Commit the steps of the `Workflow` sequence.
    ///
    /// - returns: The committed `Workflow`.
    @discardableResult
    public final func commit() -> Workflow<WorkflowActionableItemType> {
        // Side-effects must be chained at the last observable sequence, since errors and complete
        // events can be emitted by any observables on any steps of the workflow.
        let cancellable = publisher
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    self.workflow.didReceiveError(error)
                case .finished:
                    self.workflow.didCompleteIfNotYet()
                }
                self.workflow.didCompleteIfNotYet()
            })
            .subscribe()
        cancellable.store(in: &workflow.compositeCancellable)
        return workflow
    }

    /// Convert the `Workflow` into an obseravble.
    ///
    /// - returns: The type-erased publsher representation of this `Workflow`.
    public final func asPublisher() -> AnyPublisher<(ActionableItemType, ValueType), Error> {
        publisher
            .eraseToAnyPublisher()
    }

    // MARK: - Private

    fileprivate init(workflow: Workflow<WorkflowActionableItemType>,
                     publisher: AnyPublisher<(ActionableItemType, ValueType), Error>) {
        self.workflow = workflow
        self.publisher = publisher
    }

    private let workflow: Workflow<WorkflowActionableItemType>
    private var publisher: AnyPublisher<(ActionableItemType, ValueType), Error>
}

/// `Workflow` related obervable extensions.
public extension Publisher {

    /// Fork the step from this obervable.
    ///
    /// - parameter workflow: The workflow this step belongs to.
    /// - returns: The newly forked step in the workflow. `nil` if this observable does not conform to the required
    ///   generic type of (ActionableItemType, ValueType).
    func fork<WorkflowActionableItemType, ActionableItemType, ValueType>(_ workflow: Workflow<WorkflowActionableItemType>) -> Step<WorkflowActionableItemType, ActionableItemType, ValueType>? {
        guard let stepPublisher = eraseToAnyPublisher() as? AnyPublisher<(ActionableItemType, ValueType), Error> else {
            return nil
        }
        workflow.didFork()
        return .init(workflow: workflow, publisher: stepPublisher)
    }
}

/// `Workflow` related `Disposable` extensions.
public extension Cancellable {

    /// Dispose the subscription when the given `Workflow` is disposed.
    ///
    /// When using this composition, the subscription closure may freely retain the workflow itself, since the
    /// subscription closure is disposed once the workflow is disposed, thus releasing the retain cycle before the
    /// `Workflow` needs to be deallocated.
    ///
    /// - note: This is the preferred method when trying to confine a subscription to the lifecycle of a `Workflow`.
    ///
    /// - parameter workflow: The workflow to dispose the subscription with.
    func cancelWith<ActionableItemType>(workflow: Workflow<ActionableItemType>) {
        store(in: &workflow.compositeCancellable)
    }
}

public extension Publisher {

    func subscribe() -> Cancellable {
        sink(receiveCompletion: { _ in },
             receiveValue: { _ in })
    }

}
