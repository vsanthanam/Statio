# Statio 2
[![Build status](https://badge.buildkite.com/ccfb90471cd44a5cfcab3e2841fd6eceb47d2b315aee7c1d31.svg)](https://buildkite.com/varun-santhanam/statio-main-branch)
[![license](https://img.shields.io/github/license/vsanthanam/vsalert.svg)](https://en.wikipedia.org/wiki/MIT_License)
[![swift-version](https://img.shields.io/badge/Swift-5.5-orange)](https://www.swift.org)
[![xcode-version](https://img.shields.io/badge/Xcode-13.0-blue)](https://developer.apple.com)

Statio is a system activity monitor for iOS devices. It is a Swift rewrite of the existing Objective-C app of the same name 9that is already available on the app store today.

The app is comprised of the primary app target, as well as several first party libraries and third party dependencies, the latter of which are integrated using the Swift Package Manager.

- External Third Party Dependencies
    - [SnapKit](https://snapkit.io), an AutoLayout DSL
    - [CombineExt](https://github.com/CombineCommunity/CombineExt), a collection of operators, publishers and utilities for Combine, that are not provided by Apple themselves, but are common in other Reactive Frameworks and standards.
    - [Countly](https://github.com/Countly/countly-sdk-ios), Countly Product Analytics iOS SDK with macOS, watchOS and tvOS support.
    - [NeedleFoundation](https://github.com/uber/needle), Compile-time safe Swift dependency injection framework (More Details Below)
    - [iOSSnapshotTestCase](https://github.com/uber/ios-snapshot-test-case), Snapshot Testing for iOS
- External First Party Dependencies
    - [AppFoundation](https://github.com/vsanthanam/AppFoundation/), A set of common swift utilities
    - [Ombi](https://ombi.network), Reactive networking with Combine and Swift
    - [MaterialColors](https://swiftmaterialcolors.xyz), Material Design Colors in Swift
    - [StatioKit](https://github.com/vsanthanam/StatioKit), A set of system monitoring utilities in Swift.
- Internal First Party Libraries
    - ShortRibs, a trimmed down version of Uber's [RIBs](https://github.com/uber/ribs), wihout routers, using Combine instead of RxSwift
    - Logging, a wrapper for Apple Unified Logging
    - Analytics, a Swift wrapper for Countly's Objective-C SDK

Additionally, the repo makes use of the following third party tooling utilities:
- [SwiftLint](https://realm.github.io/SwiftLint/), A Swift linter
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat), A Swift formatter
- [Tuist](https://tuist.io), An xcode project generator
- [Mockolo](https://github.com/uber/ribs), Efficient Swift mock generation
- [Needle](https://github.com/uber/needle), Compile-time safe dependency injection

You need not install these utilities. The correct versions are bundled in the repo.

## Setting Up

Instead of interacting with the third party tooling directly, you use the `repo` command line utility. Start by running the bootstrap command

```
$ cd path/to/repo
$ ./repo bootstrap
```

You will need Xcode 12.5 for this command to succeed. From there, you can run `./repo develop` and generate the Xcode workspace to begin development.

## Updating the DI graph

The generated workspace automatically updates the Needle dependency graph everytime a new build is triggered within Xcode. To update the DI graph manually, run the following:

```
$ cd path/to/repo
$ ./repo generate dig
```

## Updating Mocks and Running Tests

First, generate the Xcode workspace:

```
$ cd path/to/repo
$ ./repo generate project
```

Then, update the protocol mocks:

```
$ ./repo generate mocks
```

Finally, run the unit tests:

```
$ ./repo test --pretty
```

Alternatively, you can open the generate the Xcode workspace and run the tests from there. Protocol mocks will be updated automatically.

## Linting

You can lint swift files like this:

```
$ cd path/to/repo
$ ./repo lint
```

Add the `--autofix` flag to automatically correct fixable lint errors.
