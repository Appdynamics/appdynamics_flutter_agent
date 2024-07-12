# 24.7.0
* Support for Flutter 3.22.2
* Bug Fixes: Resolved the issue causing black screenshots on Android devices.

# 24.4.0
* Included a PrivacyInfo.xcprivacy file containing the Apple privacy guidelines.
* Added enableLoggingInVSCode property (default: false) for logging within VSCode environment.

# 23.12.0
* Resolved the integration problem with Google Fonts.

# 23.11.0
* Features: Added Handling Error Implemented
* Display Flutter (Dart) level stacktrace in Crash Detail dashboard [Release Notes](https://docs.appdynamics.com/appd/23.x/23.11/en/product-and-release-announcements/release-notes#id-.ReleaseNotesv23.12-agent-enhancements-23-12AgentEnhancements)

# 23.9.0
* Resolved compatibility issues with Dio version 5.1.0.


# 23.3.0
* Promoting package from beta. 🎊
* Disabled native WebView instrumentation, which was enabled by default.
* Fixed `UniqueKey() method not found.` bug with older Flutter projects.
* Fixed native errors not being reported correctly.
* Fixed incorrect LoggingLevel values on Android.


# 22.12.0-beta.1
* Improved crash reporting by grouping exceptions and errors into different categories in the UI
* controller.
* Fixed bug involving screen tracking crashing app on start.
* Improve RequestTracker class by removing bugs involving force unwrapping the tracker.

# 22.6.0-beta.1
* Fixed bug regarding running the plugin on iOS 12.4 simulators.

# 22.5.0-beta.1
* `TrackedDioClient` class will now help with automatically tracking `dio` requests.
* Removing `uuid` package dependency for less hassle.

# 22.3.0-beta.8
* Fix agent versions in beacon logs.
* Add `applicationName` agent configuration parameter.

# 22.3.0-beta.7
* Misc README changes.

# 22.3.0-beta.6
* Changes Github repo link.
* Fixes outdated links.

# 22.3.0-beta.5
* Adds Github repo links.

# 22.3.0-beta.4
* Adds README links to docs.

# 22.3.0-beta.3
* Changed example project's name.
* Updated package homepage.
* Misc changes.

# 22.3.0-beta.2
* Changed example project's name.
* Updated package homepage.
* Misc changes.

# 22.3.0-beta.1
* Switched to calendar versioning (YY.MM.MINOR_MICRO).
* Adds example project.

# 1.0.0-beta.1

🎉🎊 Presenting the new AppDynamics SDK for Flutter:
* Allows instrumenting Flutter apps and getting valuable insights in the UI controller.
* Features: request tracking, error/crash reporting, activity tracking, info points, and many more.
* Thoroughly maintained and ready for production.