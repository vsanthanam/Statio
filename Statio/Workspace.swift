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
                              "Libraries/MonitorKit"
                          ],
                          schemes: [
                              .init(name: "Statio",
                                    shared: true,
                                    buildAction: .buildAction(targets: [.project(path: "App", target: "Statio")]),
                                    testAction: .targets([
                                        .init(target: .project(path: "App", target: "StatioTests")),
                                        .init(target: .project(path: "App", target: "StatioSnapshotTests"))
                                    ]),
                                    runAction: .runAction(executable: .project(path: "App",
                                                                               target: "Statio"),
                                                          arguments: .init(environment: ["FB_REFERENCE_IMAGE_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)SnapshotTests/ReferenceImages",
                                                                                         "IMAGE_DIFF_DIR": "$(SOURCE_ROOT)/$(PROJECT_NAME)SnapshotTests/FailureDiffs",
                                                                                         "AN_SEND_IN_DEBUG": "NO"])))
                          ],
                          additionalFiles: [])
