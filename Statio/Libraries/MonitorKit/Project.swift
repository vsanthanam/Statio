//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "MonitorKit",
                      organizationName: "Varun Santhanam",
                      packages: [],
                      settings: .project,
                      targets: [
                          Target(name: "MonitorKit",
                                 platform: .iOS,
                                 product: .framework,
                                 bundleId: "com.varunsanthanam.MonitorKit",
                                 infoPlist: "MonitorKit/Info.plist",
                                 sources: ["MonitorKit/**"],
                                 headers: Headers(public: "MonitorKit/MonitorKit.h",
                                                  private: [],
                                                  project: []),
                                 dependencies: [
                                     .remote(.snapKit),
                                     .remote(.needle)
                                 ],
                                 settings: .target(named: "MonitorKit")),
                          Target(name: "MonitorKitTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.MonitorKitTests",
                                 infoPlist: "MonitorKitTests/Info.plist",
                                 sources: ["MonitorKitTests/**"],
                                 dependencies: [
                                     .target(name: "MonitorKit")
                                 ],
                                 settings: .target(named: "MonitorKitTests"))
                      ],
                      schemes: [
                          .init(name: "MonitorKit",
                                shared: true,
                                buildAction: .buildAction(targets: ["MonitorKit"]),
                                testAction: .targets(["MonitorKitTests"]))
                      ])
