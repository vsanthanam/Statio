//
// Statio
// Varun Santhanam
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(name: "Statio",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .for(.needle),
                          .for(.appFoundation),
                          .for(.snapKit),
                          .for(.combineSchedulers),
                          .for(.combineExt),
                          .for(.ombi),
                          .for(.materialColors),
                          .for(.charts),
                          .for(.snapshotTestCase)
                      ],
                      settings: .project,
                      targets: [
                          Target(name: "Statio",
                                 platform: .iOS,
                                 product: .app,
                                 bundleId: "com.varunsanthanam.Statio",
                                 infoPlist: "Statio/Info.plist",
                                 sources: [
                                     "Statio/Src/**"
                                 ],
                                 resources: [
                                     "Statio/Resources/**"
                                 ],
                                 scripts: [
                                     .pre(script: "../../repo generate dig --repo-root ../../", name: "Generate DI Graph")
                                 ],
                                 dependencies: [
                                     .remote(.needle),
                                     .remote(.appFoundation),
                                     .remote(.snapKit),
                                     .remote(.combineExt),
                                     .remote(.ombi),
                                     .remote(.materialColors),
                                     .remote(.charts),
                                     .project(target: "MonitorKit", path: "../Libraries/MonitorKit"),
                                     .project(target: "Analytics", path: "../Libraries/Analytics"),
                                     .project(target: "Logging", path: "../Libraries/Logging"),
                                     .project(target: "ShortRibs", path: "../Libraries/ShortRibs"),
                                     .sdk(name: "UIKit.framework", status: .required),
                                     .sdk(name: "Combine.framework", status: .required),
                                     .sdk(name: "CoreData.framework", status: .required),
                                     .sdk(name: "Photos.framework", status: .required),
                                     .sdk(name: "PhotosUI.framework", status: .required)
                                 ],
                                 settings: .target(named: "Statio")),
                          Target(name: "StatioTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.StatioTests",
                                 infoPlist: "StatioTests/Info.plist",
                                 sources: [
                                     "StatioTests/**"
                                 ],
                                 scripts: [
                                     .pre(script: "../../repo generate mocks --repo-root ../../",
                                          name: "Generate Mocks")
                                 ],
                                 dependencies: [
                                     .target(name: "Statio"),
                                     .remote(.combineSchedulers)
                                 ],
                                 settings: .target(named: "StatioTests")),
                          Target(name: "StatioSnapshotTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.StatioSnapshotTests",
                                 infoPlist: "StatioSnapshotTests/Info.plist",
                                 sources: [
                                     "StatioSnapshotTests/**"
                                 ],
                                 scripts: [
                                     .pre(script: "../../repo generate mocks --repo-root ../../",
                                          name: "Generate Mocks")
                                 ],
                                 dependencies: [
                                     .target(name: "Statio"),
                                     .remote(.snapshotTestCase)
                                 ],
                                 settings: .target(named: "StatioSnapshotTests"))
                      ],
                      schemes: [
                          .init(name: "App",
                                shared: true,
                                buildAction: BuildAction(targets: ["Statio"]),
                                testAction: .targets(["StatioTests", "StatioSnapshotTests"]),
                                runAction: .runAction(executable: "Statio",
                                                      arguments: .init(environment: ["FB_REFERENCE_IMAGE_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)SnapshotTests/ReferenceImages",
                                                                                     "IMAGE_DIFF_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)ShapshotTests/FailureDiffs",
                                                                                     "AN_SEND_IN_DEBUG": "NO"])))
                      ])
