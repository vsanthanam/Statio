//
// Statio
// Varun Santhanam
//

import Foundation
import UIKit

public enum Device {

    // MARK: - API

    /// Available iOS Interface Types
    public enum Interface: String {

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

    public struct System {

        /// The name of the system
        public let name: String

        /// The version of the system
        public let version: String

        /// The uptime of the system
        public let uptime: TimeInterval

    }

    public static var name: String {
        UIDevice.current.name
    }

    public static var genericName: String {
        UIDevice.current.localizedModel
    }

    public static var identifier: String {
        modelIdentifier
    }

    public static var interface: Interface {
        UIDevice.current.interfaceType
    }

    /// The system info of the device
    public static var system: System {
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

    var interfaceType: Device.Interface {
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
