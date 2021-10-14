//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol AccelerometerViewControllable: ViewControllable {}

/// @CreateMock
protocol AccelerometerPresentableListener: AnyObject {
    func didTapBack()
}

final class AccelerometerViewController: ScopeViewController, AccelerometerPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        analayticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Accelerometer"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analayticsManager.send(event: AnalyticsEvent.accelerometer_vc_impression)
    }

    // MARK: - AccelerometerPresentable

    weak var listener: AccelerometerPresentableListener?

    // MARK: - Private

    let analayticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analayticsManager.send(event: AnalyticsEvent.accelerometer_vc_dismiss)
        listener?.didTapBack()
    }
}
