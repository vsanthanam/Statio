//
// Statio
// Varun Santhanam
//

import Foundation
import ShortRibs
@testable import Statio
import UIKit
import XCTest

final class WiFiViewControllerTests: TestCase {

    let listener = WiFiPresentableListenerMock()
    var viewController: WiFiViewController!

    override func setUp() {
        super.setUp()
        viewController = .init()
        viewController.listener = listener
    }

}
