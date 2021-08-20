//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import StatioKit
import UIKit

/// @mockable
protocol BatteryViewControllable: ViewControllable {}

/// @mockable
protocol BatteryPresentableListener: AnyObject {
    func didTapBack()
}

final class BatteryViewController: ScopeViewController, BatteryPresentable, BatteryViewControllable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Battery"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.battery_vc_impression)
    }

    // MARK: - BatteryPresentable

    weak var listener: BatteryPresentableListener?

    func update(level: Battery.Level) {}

    func update(state: Battery.State) {}

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.battery_vc_dismiss)
        listener?.didTapBack()
    }
}
