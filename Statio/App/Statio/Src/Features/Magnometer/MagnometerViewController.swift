//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol MagnometerViewControllable: ViewControllable {}

/// @CreateMock
protocol MagnometerPresentableListener: AnyObject {
    func didTapBack()
}

final class MagnometerViewController: ScopeViewController, MagnometerPresentable {

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Magnometer"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.magnometer_vc_impression)
    }

    // MARK: - MagnometerPresentable

    weak var listener: MagnometerPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.magnometer_vc_dismiss)
        listener?.didTapBack()
    }
}