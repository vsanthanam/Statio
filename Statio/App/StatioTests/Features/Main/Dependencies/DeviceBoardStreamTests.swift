//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceBoardStreamTests: TestCase {

    let deviceBoardStorage = DeviceBoardStoringMock()

    var stream: DeviceBoardStream!

    override func setUp() {
        super.setUp()
        stream = .init(deviceBoardStorage: deviceBoardStorage)
    }

    func test_subscribe_loadsFromStorage_filtersDuplicates() {
        let storedBoards = [DeviceBoard(identifier: "0", name: "0", part: "0", frequency: 0)]

        var emits = [[DeviceBoard]]()

        deviceBoardStorage.retrieveCachedBoardsHandler = {
            storedBoards
        }

        stream.boards
            .sink { boards in emits.append(boards) }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(deviceBoardStorage.retrieveCachedBoardsCallCount, 1)

        XCTAssertEqual(emits, [storedBoards])

        stream.update(boards: storedBoards)

        XCTAssertEqual(emits, [storedBoards])
    }

    func test_subscribe_loadsFromStorage_replacesNewValues() {
        let storedBoards = [DeviceBoard(identifier: "0", name: "0", part: "0", frequency: 0)]
        let newBoards = [DeviceBoard(identifier: "1", name: "1", part: "1", frequency: 1)]

        var emits = [[DeviceBoard]]()

        deviceBoardStorage.retrieveCachedBoardsHandler = {
            storedBoards
        }

        stream.boards
            .sink { boards in emits.append(boards) }
            .cancelOnTearDown(testCase: self)

        XCTAssertEqual(deviceBoardStorage.retrieveCachedBoardsCallCount, 1)

        XCTAssertEqual(emits, [storedBoards])

        stream.update(boards: newBoards)

        XCTAssertEqual(emits, [storedBoards, newBoards])
    }
}
