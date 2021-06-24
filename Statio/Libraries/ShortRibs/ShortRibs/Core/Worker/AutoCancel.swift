//
// Statio
// Varun Santhanam
//

import Combine
import Foundation

@propertyWrapper
class AutoCancel {

    // MARK: - Initializers

    init(wrappedValue value: Cancellable?) {
        cancellable = value
    }

    // MARK: - Property Wrapper

    var wrappedValue: Cancellable? {
        get {
            cancellable
        }
        set {
            guard (newValue as AnyObject) !== (cancellable as AnyObject) else {
                return
            }
            cancellable?.cancel()
            cancellable = newValue
        }
    }

    // MARK: - Private

    private var cancellable: Cancellable?

    deinit {
        cancellable?.cancel()
    }

}
