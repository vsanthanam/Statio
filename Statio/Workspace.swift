//
// Statio
// Varun Santhanam
//

import ProjectDescription

let workspace = Workspace(name: "Statio",
                          projects: [
                              "App",
                              "Libraries/Analytics",
                              "Libraries/Logging",
                              "Libraries/ShortRibs",
                              "Vendor/FBSnapshotTestCase"
                          ],
                          schemes: [
                              .init(name: "Statio",
                                    shared: true,
                                    buildAction: BuildAction(targets: [.project(path: "App", target: "Statio")]),
                                    testAction: TestAction(targets: [
                                        .init(target: .project(path: "App", target: "StatioTests"))
                                    ]),
                                    runAction: RunAction(executable: .project(path: "App",
                                                                              target: "Statio"),
                                                         arguments: .init(environment: ["FB_REFERENCE_IMAGE_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages",
                                                                                        "IMAGE_DIFF_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/FailureDiffs",
                                                                                        "AN_SEND_IN_DEBUG": "NO"])))
                          ],
                          additionalFiles: [])
