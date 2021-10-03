//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import UIKit
import XCTest

final class ReporterViewControllerTests: TestCase {

    let listener = ReporterPresentableListenerMock()

    var viewController: ReporterViewController!

    override func setUp() {
        super.setUp()
        viewController = .init()
        viewController.listener = listener
    }

    func test_viewDidLoad_prefersLargeTitles() {
        viewController.viewDidLoad()
        XCTAssertTrue(viewController.navigationBar.prefersLargeTitles)
    }

}
