//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceIdentityViewControllerTests: TestCase {

    let listener = DeviceIdentityPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let collectionView = DeviceIdentityCollectionViewableMock()
    let dataSource = DeviceIdentityDataSourceMock()

    var viewController: DeviceIdentityViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager, collectionView: collectionView, dataSource: dataSource)
        viewController.listener = listener
    }

    func test_viewDidLoad_assignsCollectionViewDelegate() {
        XCTAssertNil(collectionView.delegate)
        viewController.viewDidLoad()
        XCTAssertTrue(collectionView.delegate === viewController)
    }

    func test_viewDidAppear_sendsEvent() {
        analyticsManager.sendHandler = { event, _, _, _, _ in
            guard let event = event as? AnalyticsEvent else {
                XCTFail("Invalid Analytics Event")
                return
            }
            XCTAssertEqual(event, .device_identity_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }

    func test_apply_assignsTitle_updatesCollectionView() {
        let model = DeviceIdentityViewModel(deviceName: "Name", modelIdentifier: "id", modelName: "model", osName: "iOS", osVersion: "14.5")
        XCTAssertNil(viewController.title)
        XCTAssertEqual(dataSource.applyCallCount, 0)

        dataSource.applyHandler = { snapshot in
            XCTAssertEqual(snapshot.sectionIdentifiers.count, 2)
            XCTAssertEqual(snapshot.sectionIdentifiers.first, .hardware)
            XCTAssertEqual(snapshot.sectionIdentifiers[1], .software)
            XCTAssertEqual(snapshot.itemIdentifiers.count, 4)
            XCTAssertEqual(snapshot.itemIdentifiers.first?.title, "Model Name")
            XCTAssertEqual(snapshot.itemIdentifiers.first?.value, "model")
            XCTAssertEqual(snapshot.itemIdentifiers[1].title, "Model Identifier")
            XCTAssertEqual(snapshot.itemIdentifiers[1].value, "id")
            XCTAssertEqual(snapshot.itemIdentifiers[2].title, "Operating System")
            XCTAssertEqual(snapshot.itemIdentifiers[2].value, "iOS")
            XCTAssertEqual(snapshot.itemIdentifiers[3].title, "Version")
            XCTAssertEqual(snapshot.itemIdentifiers[3].value, "14.5")
        }

        viewController.apply(viewModel: model)

        XCTAssertEqual(viewController.title, "Name")
        XCTAssertEqual(dataSource.applyCallCount, 1)
    }
}
