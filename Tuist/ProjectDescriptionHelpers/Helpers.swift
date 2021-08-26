//
// Statio
// Varun Santhanam
//

import ProjectDescription

public protocol StatioDependency {
    var name: String { get }
}

public struct RemoteSwiftPackage: StatioDependency {

    init(name: String, url: String, minVersion: String? = nil) {
        self.name = name
        self.url = url
        self.minVersion = minVersion
    }

    public let name: String

    public let url: String

    public let minVersion: String?
}

public extension RemoteSwiftPackage {

    static let needle: RemoteSwiftPackage = .init(name: "NeedleFoundation",
                                                  url: "https://github.com/uber/needle.git",
                                                  minVersion: "0.0.0")

    static let snapKit: RemoteSwiftPackage = .init(name: "SnapKit",
                                                   url: "https://github.com/SnapKit/SnapKit.git",
                                                   minVersion: "5.0.0")

    static let combineSchedulers: RemoteSwiftPackage = .init(name: "CombineSchedulers",
                                                             url: "https://github.com/pointfreeco/combine-schedulers.git",
                                                             minVersion: "0.0.0")

    static let combineExt: RemoteSwiftPackage = .init(name: "CombineExt",
                                                      url: "https://github.com/CombineCommunity/CombineExt.git",
                                                      minVersion: "1.0.0")

    static let ombi: RemoteSwiftPackage = .init(name: "Ombi",
                                                url: "https://github.com/vsanthanam/Ombi.git")

    static let materialColors: RemoteSwiftPackage = .init(name: "MaterialColors",
                                                          url: "https://github.com/vsanthanam/MaterialColors-Swift.git",
                                                          minVersion: "0.0.0")

    static let charts: RemoteSwiftPackage = .init(name: "Charts",
                                                  url: "https://github.com/danielgindi/Charts.git",
                                                  minVersion: "4.0.0")

    static let statioKit: RemoteSwiftPackage = .init(name: "StatioKit",
                                                     url: "https://github.com/vsanthanam/StatioKit.git",
                                                     minVersion: "0.0.0")

    static let appFoundation: RemoteSwiftPackage = .init(name: "AppFoundation",
                                                         url: "https://github.com/vsanthanam/AppFoundation.git",
                                                         minVersion: "0.0.0")

    static let countly: RemoteSwiftPackage = .init(name: "Countly",
                                                   url: "https://github.com/Countly/countly-sdk-ios.git",
                                                   minVersion: "20.0.0")

    static let snapshotTestCase: RemoteSwiftPackage = .init(name: "FBSnapshotTestCase",
                                                            url: "https://github.com/uber/ios-snapshot-test-case.git",
                                                            minVersion: "7.0.0")
}

public extension Package {

    static func `for`(_ depenendency: RemoteSwiftPackage) -> Package {
        guard let minVersion = depenendency.minVersion else {
            return .remote(url: depenendency.url,
                           requirement: .branch("main"))
        }
        return .remote(url: depenendency.url,
                       requirement: .upToNextMajor(from: .init(string: minVersion)!))

    }

}

public extension Settings {
    static let project: Settings = .init(base: [:],
                                         debug: .settings([:], xcconfig: .projectConfig),
                                         release: .settings([:], xcconfig: .projectConfig),
                                         defaultSettings: .recommended)

    static func target(named targetName: String) -> Settings {
        .init(base: [:],
              debug: .settings([:], xcconfig: .targetConfig(named: targetName)),
              release: .settings([:], xcconfig: .targetConfig(named: targetName)),
              defaultSettings: .recommended)
    }
}

public extension Path {

    static let projectConfig: Path = .relativeToManifest("Config/Project.xcconfig")

    static func targetConfig(named targetName: String) -> Path {
        .relativeToManifest("Config/" + targetName + ".xcconfig")
    }

}

public extension TargetDependency {

    static func remote(_ dependency: RemoteSwiftPackage) -> TargetDependency {
        .package(product: dependency.name)
    }

}
