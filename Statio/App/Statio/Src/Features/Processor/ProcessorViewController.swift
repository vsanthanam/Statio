//
// Statio
// Varun Santhanam
//

import Analytics
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

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.processor_vc_impression)
    }

    // MARK: - ProcessorPresentable

    weak var listener: ProcessorPresentableListener?

    func present(snapshot: ProcessorSnapshot) {}

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.processor_vc_dismiss)
    }
}
