//
// Statio
// Varun Santhanam
//

import FBSnapshotTestCase
@testable import Statio
@testable import StatioMocks

final class DeviceIdentityViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_deviceIdentityViewController() {
        let collectionView = DeviceIdentityCollectionView()
        let dataSource = DeviceIdentityCollectionViewDataSource(collectionView: collectionView)
        let viewController = DeviceIdentityViewController(analyticsManager: AnalyticsManagingMock(),
                                                          collectionView: collectionView,
                                                          dataSource: dataSource)
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.apply(viewModel: DeviceIdentityViewModel(deviceName: "Name",
                                                                modelIdentifier: "Identifier",
                                                                modelName: "Model Name",
                                                                osName: "OS",
                                                                osVersion: "Version"))
        FBSnapshotVerifyViewController(viewController)
    }

}
