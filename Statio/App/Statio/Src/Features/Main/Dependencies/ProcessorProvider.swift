//
// Statio
// Varun Santhanam
//

import Foundation
import StatioKit

/// @CreateMock
protocol ProcessorProviding: AnyObject {
    func record() throws -> Processor.Usage
}

final class ProcessorProvider: ProcessorProviding {
    func record() throws -> Processor.Usage {
        try Processor.record()
    }
}
