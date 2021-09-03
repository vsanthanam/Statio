//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol DiskViewControllable: ViewControllable {}

/// @mockable
protocol DiskPresentableListener: AnyObject {
    func didTapBack()
}

final class DiskViewController: ScopeViewController, DiskPresentable, DiskViewControllable {

    // MARK: - Initializer

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Disk"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.disk_vc_impression)
    }

    // MARK: - DiskPresentable

    weak var listener: DiskPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.disk_vc_dismiss)
        listener?.didTapBack()
    }
}
