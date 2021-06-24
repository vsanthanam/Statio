//
// Statio
// Varun Santhanam
//

import Foundation

/// @mockable
public protocol PresentableInteractable: Interactable {
    var viewControllable: ViewControllable { get }
}

open class PresentableInteractor<Presenter>: Interactor, PresentableInteractable {

    // MARK: - Initializers

    /// Create a presentable interactor  for a given presenter
    /// - Parameter presenter: The presenter
    public init(presenter: Presenter) {
        self.presenter = presenter
        super.init()
    }

    // MARK: - API

    /// The presenter managed by this interactor.
    public let presenter: Presenter

    // MARK: - PresentableInteractable

    public var viewControllable: ViewControllable {
        // swiftlint:disable:next force_cast
        presenter as! ViewControllable
    }

}
