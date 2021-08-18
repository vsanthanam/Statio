//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Logging",
                      organizationName: "Varun Santhanam",
                      settings: .project,
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
                                 settings: .target(named: "Logging"))
                      ],
                      schemes: [
                          .init(name: "Logging",
                                shared: true,
                                buildAction: BuildAction(targets: ["Logging"]))
                      ])
