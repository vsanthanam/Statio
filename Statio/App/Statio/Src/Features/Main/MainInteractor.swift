//
// Statio
// Varun Santhanam
//

import Foundation
import os.log
import ShortRibs
import UIKit

/// @mockable
protocol MainPresentable: MainViewControllable {
    var listener: MainPresentableListener? { get set }
}

/// @mockable
protocol MainListener: AnyObject {}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    // MARK: - Initializers

    init(presenter: MainPresentable,
         mainDeviceModelStorageWorker: MainDeviceModelStorageWorking,
         mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking,
         mainDeviceBoardStorageWorker: MainDeviceBoardStorageWorking,
         mainDeviceBoardUpdateWorker: MainDeviceBoardUpdateWorking) {
        self.mainDeviceModelStorageWorker = mainDeviceModelStorageWorker
        self.mainDeviceModelUpdateWorker = mainDeviceModelUpdateWorker
        self.mainDeviceBoardStorageWorker = mainDeviceBoardStorageWorker
        self.mainDeviceBoardUpdateWorker = mainDeviceBoardUpdateWorker
        super.init(presenter: presenter)
        presenter.listener = self
    }

    // MARK: - API

    weak var listener: MainListener?

    // MARK: - Interactor

    override func didBecomeActive() {
        super.didBecomeActive()
        startWorkers()
    }

    // MARK: - Private

    private let mainDeviceModelStorageWorker: MainDeviceModelStorageWorking
    private let mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking
    private let mainDeviceBoardStorageWorker: MainDeviceBoardStorageWorking
    private let mainDeviceBoardUpdateWorker: MainDeviceBoardUpdateWorking

    private func startWorkers() {
        mainDeviceModelStorageWorker.start(on: self)
        mainDeviceBoardStorageWorker.start(on: self)
        mainDeviceModelUpdateWorker.start(on: self)
        mainDeviceBoardUpdateWorker.start(on: self)
    }
}
