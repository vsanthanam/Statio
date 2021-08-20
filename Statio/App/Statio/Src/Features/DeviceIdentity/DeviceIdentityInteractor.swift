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
         deviceProvider: DeviceProviding,
         deviceModelStream: DeviceModelStreaming) {
        self.deviceProvider = deviceProvider
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

    private let deviceProvider: DeviceProviding
    private let deviceModelStream: DeviceModelStreaming

    private func startObservingDeviceIdentity() {
        UIApplication.didBecomeActiveNotification.asPublisher()
            .prepend(Notification(name: UIApplication.didBecomeActiveNotification))
            .combineLatest(deviceModelStream.models) { [deviceProvider] _, models -> DeviceModel? in
                models.first(where: { $0.id == deviceProvider.modelIdentifier })
            }
            .map { [deviceProvider] model in
                DeviceIdentityViewModel(deviceName: deviceProvider.deviceName,
                                        modelIdentifier: deviceProvider.modelIdentifier,
                                        modelName: model?.name ?? "Unknown Model",
                                        osName: deviceProvider.os,
                                        osVersion: deviceProvider.version)
            }
            .removeDuplicates()
            .sink { [presenter] viewModel in
                presenter.apply(viewModel: viewModel)
            }
            .cancelOnDeactivate(interactor: self)
    }
}
