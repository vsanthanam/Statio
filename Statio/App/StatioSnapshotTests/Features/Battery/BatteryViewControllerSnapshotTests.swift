//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
@testable import StatioMocks
import XCTest

final class BatteryViewControllerSnapshotTests: SnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func test_batteryViewController() {
        let collectionView = BatteryCollectionView()
        let dataSource = BatteryCollectionViewDataSource(collectionView: collectionView)
        let viewController = BatteryViewController(analyticsManager: AnalyticsManagingMock(),
                                                   collectionView: collectionView,
                                                   dataSource: dataSource)
        viewController.loadView()
        viewController.viewDidLoad()
        viewController.update(level: 0.5)
        viewController.update(state: .discharging)
        FBSnapshotVerifyViewController(viewController)
    }

}
