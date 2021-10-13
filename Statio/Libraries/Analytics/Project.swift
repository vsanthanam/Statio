//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Analytics",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .for(.countly),
                          .for(.appFoundation)
                      ],
                      settings: .project,
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
                                     .remote(.appFoundation),
                                     .remote(.countly),
                                     .project(target: "Logging", path: "../Logging")
                                 ],
                                 settings: .target(named: "Analytics")),
                          Target(name: "AnalyticsTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.AnalyticsTests",
                                 infoPlist: "AnalyticsTests/Info.plist",
                                 sources: ["AnalyticsTests/**"],
                                 dependencies: [
                                     .target(name: "Analytics")
                                 ],
                                 settings: .target(named: "AnalyticsTests"))
                      ],
                      schemes: [
                          .init(name: "Analytics",
                                shared: true,
                                buildAction: .buildAction(targets: ["Analytics"]),
                                testAction: .targets(["AnalyticsTests"]))
                      ])
