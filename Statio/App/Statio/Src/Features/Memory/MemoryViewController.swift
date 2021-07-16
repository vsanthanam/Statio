//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol MemoryViewControllable: ViewControllable {}

/// @mockable
protocol MemoryPresentableListener: AnyObject {
    func didTapBack()
}

final class MemoryViewController: ScopeViewController, MemoryPresentable, MemoryViewControllable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memory"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.memory_vc_impression)
    }

    // MARK: - MemoryPresentable

    weak var listener: MemoryPresentableListener?

    func present(snapshot: MemoryMonitor.Snapshot) {}

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        listener?.didTapBack()
    }
}
