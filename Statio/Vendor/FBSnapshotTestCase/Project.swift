import ProjectDescription

let project = Project(name: "FBSnapshotTestCase",
                      organizationName: "Varun Santhanam",
                      settings: .init(base: [:],
                                      debug: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      release: .settings([:], xcconfig: .relativeToManifest("Config/Project.xcconfig")),
                                      defaultSettings: .recommended),
                      targets: [
                        Target(name: "FBSnapshotTestCase",
                               platform: .iOS,
                               product: .framework,
                               bundleId: "com.varunsanthanam.FBSnapshotTestCase",
                               infoPlist: "FBSnapshotTestCase/Info.plist",
                               sources: ["FBSnapshotTestCase/Sources/**"],
                               headers: Headers(public: ["FBSnapshotTestCase/Sources/Public/**"],
                                                private: [],
                                                project: ["FBSnapshotTestCase/Sources/Project/**"]),
                               dependencies: [.xctest],
                               settings: .init(base: [:],
                                               debug: .settings([:], xcconfig: .relativeToManifest("Config/FBSnapshotTestCase.xcconfig")),
                                               release: .settings([:], xcconfig: .relativeToManifest("Config/FBSnapshotTestCase.xcconfig")),
                                               defaultSettings: .recommended)),
                      ],
                      schemes: [
                        .init(name: "FBSnapshotTestCase",
                              shared: true,
                              buildAction: BuildAction(targets: ["FBSnapshotTestCase"]))
                      ])
