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
        viewController.listener = listener
    }

}
