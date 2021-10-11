//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol WiFiViewControllable: ViewControllable {}

/// @mockable
protocol WiFiPresentableListener: AnyObject {
    func didTapBack()
}

final class WiFiViewController: ScopeViewController, WiFiPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WiFi"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.wifi_vc_impression)
    }

    // MARK: - WiFiPresentable

    weak var listener: WiFiPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.wifi_vc_dismiss)
        listener?.didTapBack()
    }
}
