//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

enum DeviceInfo {

    // MARK: - API

    /// Available iOS Interface Types
    enum InterfaceType: String {

        /// iPhone
        case phone = "iPhone"

        /// iPad
        case tablet = "iPad"

        /// Apple TV
        case tv = "tv"

        /// CarPlay
        case car = "CarPlay"

        /// Mac
        case mac = "Mac"

        /// Unknown
        case unknown = "Unknown Device"
    }

    struct SystemInfo {

        /// The name of the system
        let name: String

        /// The version of the system
        let version: String

        /// The uptime of the system
        let uptime: TimeInterval

    }

    static var name: String {
        UIDevice.current.name
    }

    static var genericName: String {
        UIDevice.current.localizedModel
    }

    static var identifier: String {
        modelIdentifier
    }

    static var interface: InterfaceType {
        UIDevice.current.interfaceType
    }

    /// The system info of the device
    static var systemInfo: SystemInfo {
        .init(name: UIDevice.current.systemName,
              version: UIDevice.current.systemVersion,
              uptime: ProcessInfo.processInfo.systemUptime)
    }

    // MARK: - Private

    private static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                String(validatingUTF8: ptr)
            }
        }

        return String(validatingUTF8: modelCode ?? "") ?? "Unknown Identifier"

    }

}

private extension UIDevice {

    var interfaceType: DeviceInfo.InterfaceType {
        switch userInterfaceIdiom {
        case .phone: return .phone
        case .pad: return .tablet
        case .tv: return .tv
        case .carPlay: return .car
        case .unspecified: return .unknown
        case .mac: return .mac
        @unknown default:
            return .unknown
        }
    }

}
