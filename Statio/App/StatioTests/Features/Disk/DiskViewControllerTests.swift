//
// Statio
// Varun Santhanam
//

import Analytics
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DiskViewControllerTests: TestCase {

    let listener = DiskPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let collectionView = DiskListCollectionViewableMock()
    let dataSource = DiskListDataSourceMock()
    let byteFormatter = ByteFormattingMock()

    var viewController: DiskViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager,
                               diskListCollectionView: collectionView,
                               diskListDataSource: dataSource,
                               byteFormatter: byteFormatter)
        viewController.listener = listener
    }

    func test_viewDidLoad_setsTitle() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.title, "Disk")
    }

    func test_viewDidLoad_assignsCollectionViewDelegate() {
        XCTAssertNil(collectionView.delegate)
        viewController.viewDidLoad()
        XCTAssertTrue(collectionView.delegate === viewController)
    }

    func test_present_updatesCollectionView() {
        let snapshot = DiskSnapshot(usage: .init(total: 4, opportunisticAvailable: 2, importantAvailable: 1, available: 3), timestamp: .distantFuture)
        byteFormatter.formattedBytesForDiskHandler = { bytes in
            String(bytes)
        }

        dataSource.applyHandler = { snapshot in
            XCTAssertEqual(snapshot.sectionIdentifiers.count, 2)
            XCTAssertEqual(snapshot.sectionIdentifiers.first, .overview)
            XCTAssertEqual(snapshot.sectionIdentifiers[1], .availabilityBreakdown)
            XCTAssertEqual(snapshot.itemIdentifiers.count, 5)
            XCTAssertEqual(snapshot.itemIdentifiers[0], .legendEntry("Total", "4"))
            XCTAssertEqual(snapshot.itemIdentifiers[1], .legendEntry("Available", "3"))
            XCTAssertEqual(snapshot.itemIdentifiers[2], .legendEntry("Used", "1"))
            // TODO: - add tests once the iten identifier is figured out
        }

        XCTAssertEqual(dataSource.applyCallCount, 0)
        XCTAssertEqual(byteFormatter.formattedBytesForDiskCallCount, 0)

        viewController.present(snapshot: snapshot)

        XCTAssertEqual(dataSource.applyCallCount, 1)
        XCTAssertEqual(byteFormatter.formattedBytesForDiskCallCount, 5)
    }
}
