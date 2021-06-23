//
// Statio
// Varun Santhanam
//

import ProjectDescription

let project = Project(name: "ShortRibs",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .remote(url: "https://github.com/SnapKit/SnapKit.git",
                                  requirement: .upToNextMajor(from: "5.0.0")),
                          .remote(url: "https://github.com/uber/needle.git",
                                  requirement: .upToNextMajor(from: "0.0.0"))
                      ],
                      settings: .init(base: [:],
                                      debug: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      release: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      defaultSettings: .recommended),
                      targets: [
                          Target(name: "ShortRibs",
                                 platform: .iOS,
                                 product: .framework,
                                 bundleId: "com.varunsanthanam.ShortRibs",
                                 infoPlist: "ShortRibs/Info.plist",
                                 sources: ["ShortRibs/**"],
                                 headers: Headers(public: "ShortRibs/ShortRibs.h",
                                                  private: [],
                                                  project: []),
                                 dependencies: [
                                     .package(product: "SnapKit"),
                                     .package(product: "NeedleFoundation")
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .init(settings: [:], xcconfig: .relativeToManifest("Config/ShortRibs.xcconfig")),
                                                 release: .init(settings: [:], xcconfig: .relativeToManifest("Config/ShortRibs.xcconfig")),
                                                 defaultSettings: .recommended)),
                          Target(name: "ShortRibsTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.ShortRibsTests",
                                 infoPlist: "ShortRibsTests/Info.plist",
                                 sources: ["ShortRibsTests/**"],
                                 dependencies: [
                                     .target(name: "ShortRibs")
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .init(settings: [:], xcconfig: .relativeToManifest("Config/ShortRibsTests.xcconfig")),
                                                 release: .init(settings: [:], xcconfig: .relativeToManifest("Config/ShortRibsTests.xcconfig")),
                                                 defaultSettings: .recommended))
                      ],
                      schemes: [
                          .init(name: "ShortRibs",
                                shared: true,
                                buildAction: BuildAction(targets: ["ShortRibs"]),
                                testAction: TestAction(targets: ["ShortRibsTests"]))
                      ])
