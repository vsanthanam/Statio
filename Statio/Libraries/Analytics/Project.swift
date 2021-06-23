//
// Statio
// Varun Santhanam
//

import ProjectDescription

let project = Project(name: "Analytics",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .remote(url: "https://github.com/Countly/countly-sdk-ios.git",
                                  requirement: .upToNextMajor(from: "20.0.0")),
                          .remote(url: "git@github.com:vsanthanam/AppFoundation.git",
                                  requirement: .branch("main"))
                      ],
                      settings: .init(base: [:],
                                      debug: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      release: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      defaultSettings: .recommended),
                      targets: [
                          Target(name: "Analytics",
                                 platform: .iOS,
                                 product: .framework,
                                 bundleId: "com.varunsanthanam.Analytics",
                                 infoPlist: "Analytics/Info.plist",
                                 sources: ["Analytics/**"],
                                 headers: Headers(public: "Analytics/Analytics.h",
                                                  private: [],
                                                  project: []),
                                 dependencies: [
                                     .package(product: "AppFoundation"),
                                     .package(product: "Countly"),
                                     .project(target: "Logging", path: "../Logging")
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .settings([:], xcconfig: .relativeToManifest("Config/Analytics.xcconfig")),
                                                 release: .settings([:], xcconfig: .relativeToManifest("Config/Analytics.xcconfig")),
                                                 defaultSettings: .recommended)),
                          Target(name: "AnalyticsTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.AnalyticsTests",
                                 infoPlist: "AnalyticsTests/Info.plist",
                                 sources: ["AnalyticsTests/**"],
                                 dependencies: [
                                     .target(name: "Analytics")
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .settings([:], xcconfig: .relativeToManifest("Config/AnalyticsTests.xcconfig")),
                                                 release: .settings([:], xcconfig: .relativeToManifest("Config/AnalyticsTests.xcconfig")),
                                                 defaultSettings: .recommended))
                      ],
                      schemes: [
                          .init(name: "Analytics",
                                shared: true,
                                buildAction: BuildAction(targets: ["Analytics"]),
                                testAction: TestAction(targets: ["AnalyticsTests"]))
                      ])
