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

    var byteFormatter: ByteFormatting {
        ByteFormatter()
    }

    var deviceProvider: DeviceProviding {
        DeviceProvider()
    }

    var batteryProvider: BatteryProviding {
        BatteryProvider()
    }

    var memoryProvider: MemoryProviding {
        MemoryProvider()
    }

    var diskProvider: DiskProviding {
        DiskProvider()
    }

    var processorProvider: ProcessorProviding {
        ProcessorProvider()
    }

    // MARK: - Internal Dependencies

    fileprivate var appStateManager: AppStateManaging {
        shared { AppStateManager() }
    }

    fileprivate var deviceModelStorageWorker: DeviceModelStorageWorking {
        DeviceModelStorageWorker(deviceModelStream: deviceModelStream,
                                 mutableDeviceModelStorage: mutableDeviceModelStorage)
    }

    fileprivate var deviceModelUpdateWorker: DeviceModelUpdateWorking {
        DeviceModelUpdateWorker(mutableDeviceModelStream: mutableDeviceModelStream,
                                deviceModelUpdateProvider: deviceModelUpdateProvider)
    }

    fileprivate var deviceBoardStorageWorker: DeviceBoardStorageWorking {
        DeviceBoardStorageWorker(deviceBoardStream: deviceBoardStream,
                                 mutableDeviceBoardStorage: mutableDeviceBoardStorage)
    }

    fileprivate var deviceBoardUpdateWorker: DeviceBoardUpdateWorking {
        DeviceBoardUpdateWorker(mutableDeviceBoardStream: mutableDeviceBoardStream,
                                deviceBoardUpdateProvider: deviceBoardUpdateProvider)
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

    private var deviceBoardUpdateProvider: DeviceBoardUpdateProviding {
        DeviceBoardUpdateProvider()
    }

    private var deviceModelUpdateProvider: DeviceModelUpdateProviding {
        DeviceModelUpdateProvider()
    }

    // MARK: - Children

    fileprivate var monitorBuilder: MonitorBuildable {
        MonitorBuilder { MonitorComponent(parent: self) }
    }

    fileprivate var reporterBuilder: ReporterBuildable {
        ReporterBuilder { ReporterComponent(parent: self) }
    }

    fileprivate var settingsBuilder: SettingsBuildable {
        SettingsBuilder { SettingsComponent(parent: self) }
    }
}

/// @CreateMock
protocol MainInteractable: PresentableInteractable, MonitorListener, ReporterListener, SettingsListener {}

typealias MainDynamicBuildDependency = (
    MainListener
)

/// @CreateMock
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
                                        deviceModelStorageWorker: component.deviceModelStorageWorker,
                                        deviceModelUpdateWorker: component.deviceModelUpdateWorker,
                                        deviceBoardStorageWorker: component.deviceBoardStorageWorker,
                                        deviceBoardUpdateWorker: component.deviceBoardUpdateWorker,
                                        monitorBuilder: component.monitorBuilder,
                                        reporterBuilder: component.reporterBuilder,
                                        settingsBuilder: component.settingsBuilder)
        interactor.listener = listener
        return interactor
    }

    // MARK: - MainBuildable

    func build(withListener listener: MainListener) -> PresentableInteractable {
        build(withDynamicBuildDependency: listener)
    }

}
