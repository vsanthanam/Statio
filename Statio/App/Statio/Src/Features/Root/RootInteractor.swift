//
// Aro
// Varun Santhanam
//

import Analytics
import Foundation
import ShortRibs

/// @mockable
protocol RootPresentable: RootViewControllable {
    var listener: RootPresentableListener? { get set }
    func showMain(_ viewControllable: ViewControllable)
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    // MARK: - Initializers

    init(presenter: RootPresentable,
         analyticsManager: AnalyticsManaging,
         mainBuilder: MainBuildable) {
        self.mainBuilder = mainBuilder
        self.analyticsManager = analyticsManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        analyticsManager.send(event: AnalyticsEvent.root_become_active)
        attachMain()
    }

    // MARK: - Private

    private let mainBuilder: MainBuildable
    private let analyticsManager: AnalyticsManaging

    private var main: PresentableInteractable?

    private func attachMain() {
        if let main = main {
            detach(child: main)
        }
        let main = mainBuilder.build(withListener: self)
        attach(child: main)
        presenter.showMain(main.viewControllable)
        self.main = main
    }
}
