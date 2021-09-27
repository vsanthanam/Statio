//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol ProcessorViewControllable: ViewControllable {}

/// @mockable
protocol ProcessorPresentableListener: AnyObject {
    func didTapBack()
}

final class ProcessorViewController: ScopeViewController, ProcessorPresentable {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Processor"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    // MARK: - ProcessorPresentable

    weak var listener: ProcessorPresentableListener?

    // MARK: - Private

    @objc
    private func didTapBack() {
        listener?.didTapBack()
    }

}
