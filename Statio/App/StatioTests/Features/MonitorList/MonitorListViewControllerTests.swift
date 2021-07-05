//
// Statio
// Varun Santhanam
//

@testable import Analytics
import Foundation
@testable import Statio
import XCTest

final class MonitorListViewControllerTests: TestCase {

    let listener = MonitorListPresentableListenerMock()
    let analyticsManager = AnalyticsManagingMock()
    let collectionView = MonitorListCollectionViewableMock()
    let dataSource = MonitorListDataSourceMock()

    var viewController: MonitorListViewController!

    override func setUp() {
        super.setUp()
        viewController = .init(analyticsManager: analyticsManager,
                               collectionView: collectionView,
                               dataSource: dataSource)
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
            XCTAssertEqual(event, .monitor_list_vc_impression)
        }

        XCTAssertEqual(analyticsManager.sendCallCount, 0)
        viewController.viewDidAppear(true)
        XCTAssertEqual(analyticsManager.sendCallCount, 1)
    }

    func test_applyIdentifiers_callsDataSource() {
        XCTAssertEqual(dataSource.applyCallCount, 0)
        dataSource.applyHandler = { dataSource in
            XCTAssertEqual(dataSource.sectionIdentifiers, MonitorCategoryIdentifier.allCases)
        }
        viewController.applyIdentifiers(MonitorIdentifier.allCases, categories: MonitorCategoryIdentifier.allCases)
        XCTAssertEqual(dataSource.applyCallCount, 1)
    }

    func test_didSelectCell_callsListener() {
        listener.didSelectMonitorHandler = { identifier in
            XCTAssertEqual(identifier, .memory)
        }

        dataSource.itemIdentifierHandler = { indexPath in
            XCTAssertEqual(indexPath, .init(row: 5, section: 0))
            return .memory
        }

        XCTAssertEqual(listener.didSelectMonitorCallCount, 0)
        XCTAssertEqual(dataSource.itemIdentifierCallCount, 0)

        viewController.collectionView(.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()), didSelectItemAt: .init(row: 5, section: 0))

        XCTAssertEqual(listener.didSelectMonitorCallCount, 1)
        XCTAssertEqual(dataSource.itemIdentifierCallCount, 1)
    }

}
