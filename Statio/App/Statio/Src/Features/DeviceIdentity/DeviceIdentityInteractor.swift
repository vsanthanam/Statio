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
protocol DeviceIdentityListener: AnyObject {
    func deviceIdentityDidClose()
}

final class DeviceIdentityInteractor: PresentableInteractor<DeviceIdentityPresentable>, DeviceIdentityInteractable, DeviceIdentityPresentableListener {

    // MARK: - Initializers

    init(presenter: DeviceIdentityPresentable,
         deviceStaticInfoProvider: DeviceStaticInfoProviding,
         deviceModelStream: DeviceModelStreaming) {
        self.deviceStaticInfoProvider = deviceStaticInfoProvider
        self.deviceModelStream = deviceModelStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: DeviceIdentityListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startObservingDeviceIdentity()
    }

    // MARK: - DeviceIdentityPresentableListener

    func didTapBack() {
        listener?.deviceIdentityDidClose()
    }

    // MARK: - Private

    private let deviceStaticInfoProvider: DeviceStaticInfoProviding
    private let deviceModelStream: DeviceModelStreaming

    private func startObservingDeviceIdentity() {
        UIApplication.didBecomeActiveNotification.asPublisher()
            .prepend(Notification(name: UIApplication.didBecomeActiveNotification))
            .combineLatest(deviceModelStream.models) { [deviceStaticInfoProvider] _, models -> DeviceModel? in
                models.first(where: { $0.id == deviceStaticInfoProvider.modelIdentifier })
            }
            .map { [deviceStaticInfoProvider] model in
                DeviceIdentityViewModel(deviceName: deviceStaticInfoProvider.deviceName,
                                        modelIdentifier: deviceStaticInfoProvider.modelIdentifier,
                                        modelName: model?.name ?? "Unknown Model",
                                        osName: deviceStaticInfoProvider.os,
                                        osVersion: deviceStaticInfoProvider.version)
            }
            .removeDuplicates()
            .sink { [presenter] viewModel in
                presenter.apply(viewModel: viewModel)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
