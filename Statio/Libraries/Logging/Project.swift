//
// Statio
// Varun Santhanam
//

import ProjectDescription

let project = Project(name: "Logging",
                      organizationName: "Varun Santhanam",
                      settings: .init(base: [:],
                                      debug: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      release: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      defaultSettings: .recommended),
                      targets: [
                          Target(name: "Logging",
                                 platform: .iOS,
                                 product: .framework,
                                 bundleId: "com.varunsanthanam.Logging",
                                 infoPlist: "Logging/Info.plist",
                                 sources: ["Logging/**"],
                                 headers: Headers(public: "Logging/Logging.h",
                                                  private: [],
                                                  project: []),
                                 dependencies: [],
                                 settings: .init(base: [:],
                                                 debug: .settings([:], xcconfig: .relativeToManifest("Config/Logging.xcconfig")),
                                                 release: .settings([:], xcconfig: .relativeToManifest("Config/Logging.xcconfig")),
                                                 defaultSettings: .recommended))
                      ],
                      schemes: [
                          .init(name: "Logging",
                                shared: true,
                                buildAction: BuildAction(targets: ["Logging"]))
                      ])
