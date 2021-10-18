//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs
import UIKit

/// @CreateMock
protocol CompassViewControllable: ViewControllable {}

/// @CreateMock
protocol CompassPresentableListener: AnyObject {
    func didTapBack()
}

final class CompassViewController: ScopeViewController, CompassPresentable {

    // MARK: - Initializers

    init(analyticsManager: AnalyticsManaging) {
        self.analyticsManager = analyticsManager
        super.init()
    }

    // MARK: - UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsManager.send(event: AnalyticsEvent.compass_vc_impression)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compass"
        let leadingItem = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didTapBack))
        navigationItem.leftBarButtonItem = leadingItem
        specializedView.backgroundColor = .systemBackground
    }

    // MARK: - CompassPresentable

    weak var listener: CompassPresentableListener?

    // MARK: - Private

    private let analyticsManager: AnalyticsManaging

    @objc
    private func didTapBack() {
        analyticsManager.send(event: AnalyticsEvent.compass_vc_dismiss)
        listener?.didTapBack()
    }
}
