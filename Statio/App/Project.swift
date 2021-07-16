//
// Statio
// Varun Santhanam
//

import ProjectDescription

let project = Project(name: "Statio",
                      organizationName: "Varun Santhanam",
                      packages: [
                          .remote(url: "https://github.com/uber/needle.git",
                                  requirement: .upToNextMajor(from: "0.0.0")),
                          .remote(url: "git@github.com:vsanthanam/AppFoundation.git",
                                  requirement: .upToNextMajor(from: "0.0.0")),
                          .remote(url: "https://github.com/SnapKit/SnapKit.git",
                                  requirement: .upToNextMajor(from: "5.0.0")),
                          .remote(url: "https://github.com/pointfreeco/combine-schedulers.git",
                                  requirement: .upToNextMajor(from: "0.0.0")),
                          .remote(url: "https://github.com/CombineCommunity/CombineExt.git",
                                  requirement: .upToNextMajor(from: "1.0.0")),
                          .remote(url: "https://github.com/vsanthanam/Ombi.git",
                                  requirement: .branch("main")),
                          .remote(url: "https://github.com/vsanthanam/MaterialColors-Swift.git",
                                  requirement: .upToNextMajor(from: "0.0.0")),
                          .remote(url: "https://github.com/danielgindi/Charts.git",
                                  requirement: .upToNextMajor(from: "4.0.0")),
                          .remote(url: "git@github.com:vsanthanam/StatioKit.git",
                                  requirement: .upToNextMajor(from: "0.0.0"))
                      ],
                      settings: .init(base: [:],
                                      debug: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      release: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      defaultSettings: .recommended),
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
                                 actions: [
                                     .pre(script: "../../repo update-deps --repo-root ../../", name: "Generate DI Graph")
                                 ],
                                 dependencies: [
                                     .package(product: "NeedleFoundation"),
                                     .package(product: "AppFoundation"),
                                     .package(product: "SnapKit"),
                                     .package(product: "CombineExt"),
                                     .package(product: "Ombi"),
                                     .package(product: "MaterialColors"),
                                     .package(product: "Charts"),
                                     .package(product: "StatioKit"),
                                     .project(target: "Analytics", path: "../Libraries/Analytics"),
                                     .project(target: "Logging", path: "../Libraries/Logging"),
                                     .project(target: "ShortRibs", path: "../Libraries/ShortRibs"),
                                     .sdk(name: "UIKit.framework", status: .required),
                                     .sdk(name: "Combine.framework", status: .required),
                                     .sdk(name: "CoreData.framework", status: .required),
                                     .sdk(name: "Photos.framework", status: .required),
                                     .sdk(name: "PhotosUI.framework", status: .required)
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .settings([:], xcconfig: .relativeToManifest("Config/Statio.xcconfig")),
                                                 release: .settings([:], xcconfig: .relativeToManifest("Config/Statio.xcconfig")),
                                                 defaultSettings: .recommended)),
                          Target(name: "StatioTests",
                                 platform: .iOS,
                                 product: .unitTests,
                                 bundleId: "com.varunsanthanam.StatioTests",
                                 infoPlist: "StatioTests/Info.plist",
                                 sources: [
                                     "StatioTests/**"
                                 ],
                                 actions: [
                                     .pre(script: "../../repo mock --repo-root ../../",
                                          name: "Generate Mocks")
                                 ],
                                 dependencies: [
                                     .target(name: "Statio"),
                                     .package(product: "CombineSchedulers"),
                                     .project(target: "FBSnapshotTestCase", path: "../Vendor/FBSnapshotTestCase")
                                 ],
                                 settings: .init(base: [:],
                                                 debug: .settings([:], xcconfig: .relativeToManifest("Config/StatioTests.xcconfig")),
                                                 release: .settings([:], xcconfig: .relativeToManifest("Config/StatioTests.xcconfig")),
                                                 defaultSettings: .recommended))
                      ],
                      schemes: [
                          .init(name: "App",
                                shared: true,
                                buildAction: BuildAction(targets: ["Statio"]),
                                testAction: TestAction(targets: ["StatioTests"]),
                                runAction: RunAction(executable: "Statio",
                                                     arguments: .init(environment: ["FB_REFERENCE_IMAGE_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages",
                                                                                    "IMAGE_DIFF_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/FailureDiffs",
                                                                                    "AN_SEND_IN_DEBUG": "NO"])))
                      ])
