//
// Statio
// Varun Santhanam
//

import Combine
import Foundation
@testable import ShortRibs
@testable import Statio
import XCTest

final class DeviceBoardStorageWorkerTests: TestCase {

    let boardsSubject = PassthroughSubject<[DeviceBoard], Never>()
    let deviceBoardStream = DeviceBoardStreamingMock()
    let mutableDeviceBoardStorage = MutableDeviceBoardStoringMock()

    var worker: DeviceBoardStorageWorker!

    override func setUp() {
        super.setUp()
        deviceBoardStream.boards = boardsSubject.eraseToAnyPublisher()
        worker = .init(deviceBoardStream: deviceBoardStream,
                       mutableDeviceBoardStorage: mutableDeviceBoardStorage)
    }

    func test_newModels_updatesStorage() {
        let interactor = Interactor()
        worker.start(on: interactor)
        interactor.activate()

        XCTAssertEqual(mutableDeviceBoardStorage.storeBoardsCallCount, 0)

        let newBoards = [DeviceBoard(identifier: "0", name: "0", part: "0", frequency: 0)]

        mutableDeviceBoardStorage.storeBoardsHandler = { boards in
            XCTAssertEqual(boards, newBoards)
        }

        boardsSubject.send(newBoards)

        XCTAssertEqual(mutableDeviceBoardStorage.storeBoardsCallCount, 1)
    }

}
