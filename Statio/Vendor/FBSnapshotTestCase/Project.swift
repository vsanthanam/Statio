//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "FBSnapshotTestCase",
                      organizationName: "Varun Santhanam",
                      settings: .project,
                      targets: [
                          Target(name: "FBSnapshotTestCase",
                                 platform: .iOS,
                                 product: .framework,
                                 bundleId: "com.varunsanthanam.FBSnapshotTestCase",
                                 infoPlist: "FBSnapshotTestCase/Info.plist",
                                 sources: [
                                     "FBSnapshotTestCase/Sources/**",
                                 ],
                                 headers: Headers(public: [
                                     "FBSnapshotTestCase/Sources/Public/**",
                                 ],
                                 private: [],
                                 project: [
                                     "FBSnapshotTestCase/Sources/Project/**",
                                 ]),
                                 dependencies: [
                                     .xctest,
                                 ],
                                 settings: .target(named: "FBSnapshotTestCase")),
                      ],
                      schemes: [
                          .init(name: "FBSnapshotTestCase",
                                shared: true,
                                buildAction: BuildAction(targets: ["FBSnapshotTestCase"])),
                      ])
