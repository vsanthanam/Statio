//
// Statio
// Varun Santhanam
//

import AppFoundation
import Foundation
import ShortRibs
import UIKit

/// @mockable
protocol DeviceIdentityPresentable: DeviceIdentityViewControllable {
    var listener: DeviceIdentityPresentableListener? { get set }
    func apply(viewModel: DeviceIdentityViewModel)
}

/// @mockable
protocol DeviceIdentityListener: AnyObject {}

final class DeviceIdentityInteractor: PresentableInteractor<DeviceIdentityPresentable>, DeviceIdentityInteractable, DeviceIdentityPresentableListener {

    // MARK: - Initializers

    init(presenter: DeviceIdentityPresentable,
         deviceNameProvider: DeviceNameProviding) {
        self.deviceNameProvider = deviceNameProvider
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        applyLatestViewModel()
        startObservingApplicationLifecycle()
    }

    // MARK: - API

    weak var listener: DeviceIdentityListener?

    // MARK: - Private

    private let deviceNameProvider: DeviceNameProviding

    private func buildViewModel() -> DeviceIdentityViewModel {
        .init(deviceName: deviceNameProvider.buildLatestName())
    }

    private func applyLatestViewModel() {
        let viewModel = buildViewModel()
        presenter.apply(viewModel: viewModel)
    }

    private func startObservingApplicationLifecycle() {
        UIApplication.didBecomeActiveNotification.asPublisher()
            .sink { _ in
                self.applyLatestViewModel()
            }
            .cancelOnDeactivate(interactor: self)
    }
}
