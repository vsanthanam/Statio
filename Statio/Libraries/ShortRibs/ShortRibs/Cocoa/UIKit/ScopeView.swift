//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
import UIKit

/// @mockable
public protocol Viewable: AnyObject {
    var uiview: UIView { get }
}

extension UIView: Viewable {
    public var uiview: UIView { self }
}

open class ScopeView: UIView {

    // MARK: - Initializers

    public init() {
        super.init(frame: .zero)
    }

    // MARK: - Unavailable

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Don't use interface builder 😡")
    }

    // MARK: - Private

    fileprivate func store(cancellable: Cancellable) {
        cancellable.store(in: &storage)
    }

    private var storage = Set<AnyCancellable>()

    // MARK: - Deinit

    deinit {
        storage.forEach { cancellable in cancellable.cancel() }
        storage.removeAll()
    }

}
