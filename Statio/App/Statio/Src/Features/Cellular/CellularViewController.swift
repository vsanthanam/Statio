//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol CellularViewControllable: ViewControllable {}

/// @mockable
protocol CellularPresentableListener: AnyObject {
    func didTapBack()
}

final class CellularViewControler: ScopeViewController, CellularPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cellular"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.cellular_vc_impression)
    }

    // MARK: - CellularPresentable

    weak var listener: CellularPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.cellular_vc_dismiss)
        listener?.didTapBack()
    }

}
