//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "ShortRibs",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .for(.snapKit),
                          .for(.needle)
                      ],
                      settings: .project,
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
                                     .remote(.snapKit),
                                     .remote(.needle)
                                 ],
                                 settings: .target(named: "ShortRibs")),
                          Target(name: "ShortRibsTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.ShortRibsTests",
                                 infoPlist: "ShortRibsTests/Info.plist",
                                 sources: ["ShortRibsTests/**"],
                                 dependencies: [
                                     .target(name: "ShortRibs")
                                 ],
                                 settings: .target(named: "ShortRibsTests"))
                      ],
                      schemes: [
                          .init(name: "ShortRibs",
                                shared: true,
                                buildAction: BuildAction(targets: ["ShortRibs"]),
                                testAction: TestAction(targets: ["ShortRibsTests"]))
                      ])
