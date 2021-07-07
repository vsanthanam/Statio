# Statio 2

Statio is a system activity monitor for iOS devices. It is a Swift rewrite of the existing Objective-C app of the same name 9that is already available on the app store today.

The app is comprised of the primary app target, as well as several first party libraries and third party dependencies, the latter of which are integrated using the Swift Package Manager.

- External Third Party Dependencies
    - [SnapKit](https://snapkit.io), an AutoLayout DSL
    - [CombineExt](https://github.com/CombineCommunity/CombineExt), a collection of operators, publishers and utilities for Combine, that are not provided by Apple themselves, but are common in other Reactive Frameworks and standards.
    - [Countly](https://github.com/Countly/countly-sdk-ios), Countly Product Analytics iOS SDK with macOS, watchOS and tvOS support.
    - [NeedleFoundation](https://github.com/uber/needle), Compile-time safe Swift dependency injection framework (More Details Below)
- External First Party Dependencies
    - [AppFoundation]
    - [Ombi]
    - [MaterialColors]
- Internal Third Party Libraries
    - [iOSSnapshotTestCase]
- Internal First Party Libraries
    - ShortRibs
    - Logging
    - Analytics