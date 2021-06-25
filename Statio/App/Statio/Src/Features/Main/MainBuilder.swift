//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
import NeedleFoundation
import ShortRibs

protocol MainDependency: Dependency {
    var analyticsManager: AnalyticsManaging { get }
}

final class MainComponent: Component<MainDependency> {

    // MARK: - Published Dependencies

    var resourceProvider: ResourceProviding {
        ResourceProvider()
    }

    var deviceModelStream: DeviceModelStreaming {
        mutableDeviceModelStream
    }

    var deviceBoardStream: DeviceBoardStreaming {
        mutableDeviceBoardStream
    }

    var appStateProviding: AppStateProviding {
        appStateManager
    }

    // MARK: - Internal Dependencies

    fileprivate var mainDeviceModelStorageWorker: MainDeviceModelStorageWorking {
        MainDeviceModelStorageWorker(deviceModelStream: deviceModelStream, mutableDeviceModelStorage: mutableDeviceModelStorage)
    }

    fileprivate var mainDeviceModelUpdateWorker: MainDeviceModelUpdateWorking {
        MainDeviceModelUpdateWorker(mutableDeviceModelStream: mutableDeviceModelStream)
    }

    fileprivate var mainDeviceBoardStorageWorker: MainDeviceBoardStorageWorking {
        MainDeviceBoardStorageWorker(deviceBoardStream: deviceBoardStream, mutableDeviceBoardStorage: mutableDeviceBoardStorage)
    }

    fileprivate var mainDeviceBoardUpdateWorker: MainDeviceBoardUpdateWorking {
        MainDeviceBoardUpdateWorker(mutableDeviceBoardStream: mutableDeviceBoardStream)
    }

    fileprivate var appStateManager: AppStateManaging {
        shared { AppStateManager() }
    }

    // MARK: - Private Dependencies

    private var mutableDeviceModelStream: MutableDeviceModelStreaming {
        shared { DeviceModelStream(deviceModelStorage: deviceModelStorage) }
    }

    private var mutableDeviceModelStorage: MutableDeviceModelStoring {
        DeviceModelStorage()
    }

    private var deviceModelStorage: DeviceModelStoring {
        mutableDeviceModelStorage
    }

    private var mutableDeviceBoardStream: MutableDeviceBoardStreaming {
        shared { DeviceBoardStream(deviceBoardStorage: deviceBoardStorage) }
    }

    private var mutableDeviceBoardStorage: MutableDeviceBoardStoring {
        DeviceBoardStorage()
    }

    private var deviceBoardStorage: DeviceBoardStoring {
        mutableDeviceBoardStorage
    }

    // MARK: - Children

    fileprivate var monitorBuilder: MonitorBuildable {
        MonitorBuilder { MonitorComponent(parent: self) }
    }

    fileprivate var settingsBuilder: SettingsBuildable {
        SettingsBuilder { SettingsComponent(parent: self) }
    }
}

/// @mockable
protocol MainInteractable: PresentableInteractable, MonitorListener, SettingsListener {}

typealias MainDynamicBuildDependency = (
    MainListener
)

/// @mockable
protocol MainBuildable: Buildable {
    func build(withListener listener: MainListener) -> PresentableInteractable
}

final class MainBuilder: ComponentizedBuilder<MainComponent, PresentableInteractable, MainDynamicBuildDependency, Void>, MainBuildable {

    // MARK: - ComponentizedBuilder

    override func build(with component: MainComponent, _ dynamicBuildDependency: MainDynamicBuildDependency) -> PresentableInteractable {
        let listener = dynamicBuildDependency
        let viewController = MainViewController(analyticsManager: component.analyticsManager)
        let interactor = MainInteractor(presenter: viewController,
                                        appStateManager: component.appStateManager,
                                        mainDeviceModelStorageWorker: component.mainDeviceModelStorageWorker,
                                        mainDeviceModelUpdateWorker: component.mainDeviceModelUpdateWorker,
                                        mainDeviceBoardStorageWorker: component.mainDeviceBoardStorageWorker,
                                        mainDeviceBoardUpdateWorker: component.mainDeviceBoardUpdateWorker,
                                        monitorBuilder: component.monitorBuilder,
                                        settingsBuilder: component.settingsBuilder)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MainBuildable

    func build(withListener listener: MainListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
