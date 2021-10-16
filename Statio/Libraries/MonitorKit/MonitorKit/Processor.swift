//
// Statio
// Varun Santhanam
//

import Foundation

public enum Processor {

    public struct Usage: Equatable, Hashable {

        public struct CoreUsage: Equatable, Hashable {

            public var user: Double {
                Double(userStored) / Double(totalStored)
            }

            public var nice: Double {
                Double(niceStored) / Double(totalStored)
            }

            public var system: Double {
                Double(systemStored) / Double(totalStored)
            }

            public var idle: Double {
                Double(idleStored) / Double(totalStored)
            }

            public var usage: Double {
                Double(userStored + systemStored + niceStored + niceStored) / Double(totalStored)
            }

            init(userStored: Int32,
                 niceStored: Int32,
                 systemStored: Int32,
                 idleStored: Int32) {
                self.userStored = userStored
                self.niceStored = niceStored
                self.systemStored = systemStored
                self.idleStored = idleStored
            }

            // MARK: - Private

            private let userStored: Int32
            private let niceStored: Int32
            private let systemStored: Int32
            private let idleStored: Int32

            private var totalStored: Int32 {
                userStored + niceStored + systemStored + idleStored
            }

        }

        /// Total unweighted average usage, across all cores
        public var totalUsage: Double {
            (usage.map(\.usage).reduce(0.0, +) / Double(usage.count))
        }

        /// Usage for a given core
        /// - Parameter core: The index of the core
        /// - Returns: The usage of the core at the given index, or `nil` if no such core exists
        public func usage(forCore core: Int) -> CoreUsage? {
            guard core < usage.count else {
                return nil
            }
            return usage[core]
        }

        public init(usage: [CoreUsage]) {
            self.usage = usage
        }

        // MARK: - Private

        private let usage: [CoreUsage]

    }

    public static func record() throws -> Usage {
        let cores = try SystemControl.data(for: [CTL_HW, HW_NCPU])

        let lock = NSLock()

        var num = UInt32(0)
        let err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &num, &info, &info_size)

        guard err == KERN_SUCCESS, let current_info = info else {
            throw SystemControl.Error.unknown
        }

        lock.lock()

        var usage = [Usage.CoreUsage]()

        for core in cores {

            let user: Int32
            let system: Int32
            let nice: Int32
            let idle: Int32

            if let prev_info = prev_info {
                user = current_info.user(forCore: core) - prev_info.user(forCore: core)
                system = current_info.system(forCore: core) - prev_info.system(forCore: core)
                nice = current_info.nice(forCore: core) - prev_info.nice(forCore: core)
                idle = current_info.idle(forCore: core) - prev_info.idle(forCore: core)
            } else {
                user = current_info.user(forCore: core)
                system = current_info.system(forCore: core)
                nice = current_info.nice(forCore: core)
                idle = current_info.idle(forCore: core)
            }

            let data = Usage.CoreUsage(userStored: user,
                                       niceStored: nice,
                                       systemStored: system,
                                       idleStored: idle)

            usage.append(data)
        }

        lock.unlock()

        if prev_info != nil {
            let prev_size: size_t = MemoryLayout<integer_t>.stride * Int(prev_info_size)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: prev_info), vm_size_t(prev_size))
        }

        prev_info = info
        prev_info_size = info_size

        info = nil
        info_size = 0

        return .init(usage: usage)
    }

    private static var timer: Timer?
    private static var info: processor_info_array_t? = nil
    private static var prev_info: processor_info_array_t? = nil
    private static var info_size: mach_msg_type_number_t = 0
    private static var prev_info_size: mach_msg_type_number_t = 0

}

private extension processor_info_array_t {

    func user(forCore core: Int8) -> Int32 {
        self[Int((CPU_STATE_MAX * Int32(core)) + CPU_STATE_USER)]
    }

    func system(forCore core: Int8) -> Int32 {
        self[Int((CPU_STATE_MAX * Int32(core)) + CPU_STATE_SYSTEM)]
    }

    func nice(forCore core: Int8) -> Int32 {
        self[Int((CPU_STATE_MAX * Int32(core)) + CPU_STATE_NICE)]
    }

    func idle(forCore core: Int8) -> Int32 {
        self[Int((CPU_STATE_MAX * Int32(core)) + CPU_STATE_IDLE)]
    }

    func not_idle(forCore core: Int8) -> Int32 {
        user(forCore: core) + system(forCore: core) + nice(forCore: core)
    }

    func total(forCore core: Int8) -> Int32 {
        not_idle(forCore: core) + idle(forCore: core)
    }
}
