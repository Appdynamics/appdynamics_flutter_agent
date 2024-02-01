/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'crash_report_summary.dart';

enum LoggingLevel { none, info, verbose }

/// Configuration object for the AppDynamics agent.
///
/// ```dart
/// AgentConfiguration config = AgentConfiguration(
///     appKey: "ABC-DEF-GHI",
///     loggingLevel: LoggingLevel.verbose);
/// await Instrumentation.start(config);
/// ```
/// **Note:** Replace "ABC-DEF-GHI" with your actual application key.
///
/// For more specialized use cases, like using an on-premise collector, use the
/// other, more advanced options supported by this class.
class AgentConfiguration {
  /// Sets the application key used by the agent. (required)
  final String appKey;

  /// The URL of the collector. It should be compliant with "1.4. Hierarchical
  /// URI and Relative Forms" of
  /// [RFC2396](https://www.ietf.org/rfc/rfc2396.txt).
  ///
  /// The agent will send beacons to this collector.
  final String collectorURL;

  /// The URL of the screenshot service to which the agent will upload
  /// screenshots.
  ///
  /// This is NOT your controller URL. You likely do not need to call this
  /// method unless you have an AppDynamics managed private cloud (very rare).
  ///
  /// **Note:** If you have an on-premise EUM Processor and set the collector
  /// URL in [collectorURL], then you do not need to call this method because
  /// the two URLs are the same, and the agent assumes that is the case.
  final String screenshotURL;

  /// Bool indicating if screenshot capture is enabled. (default = enabled).
  ///
  /// If enabled, the [Instrumentation.takeScreenshot] method will capture
  /// screenshots, and depending on the configuration in the controller,
  /// automatic screenshots can be taken. You can always disable screenshots
  /// entirely from your controller.
  ///
  /// If disabled, the [Instrumentation.takeScreenshot] method will NOT capture
  /// screenshots and no automatic screenshots will be captured. You will NOT
  /// be able to enable screenshots from your controller.
  ///
  /// Most applications should leave this option enabled and control the
  /// screenshots from the controller configuration page.
  final bool screenshotsEnabled;

  /// The logging level of the agent. Default is [LoggingLevel.none].
  ///
  /// **Warning:** Altering this value is not recommended for production use.
  final LoggingLevel loggingLevel;

  /// A callback function that will be triggered on a native crash. You can use
  /// this callback to have access to crash reports.
  final CrashReportCallback? crashReportCallback;

  /// A bool indicating if the crash reporter should be enabled. Default is
  /// `true`.
  ///
  /// Most applications should leave this feature enabled.
  /// Disable if you are using a different crash reporting tool and conflicts
  /// are occurring.
  final bool crashReportingEnabled;

  /// Sets the name of this mobile application. If not set, it will try to be
  /// inferred.
  ///
  /// [applicationName] must follow reverse DNS format, like a bundle ID:
  /// `com.myapplication.applicationName`.
  ///
  /// [applicationName] may contain uppercase or lowercase letters
  /// ('A' through 'Z'), numbers, and underscores ('_').
  ///
  /// If this property is set, all data reported from this application is
  /// associated with `applicationName` and appears together in dashboards.
  final String? applicationName;

  final bool enableLoggingInVSCode;

  AgentConfiguration({
    required this.appKey,
    this.collectorURL = "https://mobile.eum-appdynamics.com",
    this.screenshotURL = "https://mobile.eum-appdynamics.com",
    this.loggingLevel = LoggingLevel.none,
    this.screenshotsEnabled = true,
    this.crashReportingEnabled = true,
    this.crashReportCallback,
    this.applicationName,
    this.enableLoggingInVSCode = false,
  });

  /// Creates a new [AgentConfiguration] with possibility to overwrite existing
  /// properties.
  ///
  /// Useful when needing to conditionally add properties, as with a boolean
  /// flag variable.
  ///
  /// ```dart
  /// AgentConfiguration config = AgentConfiguration(appKey: "ABC-DEF-GHI");
  ///
  /// if (shouldEnableLogging) {
  ///    config = config.copyWith(loggingLevel: LoggingLevel.verbose);
  /// }
  ///
  /// await Instrumentation.start(config);
  /// ```
  AgentConfiguration copyWith(
      {String? appKey,
      String? collectorURL,
      String? screenshotURL,
      bool? screenshotsEnabled,
      LoggingLevel? loggingLevel,
      CrashReportCallback? crashReportCallback,
      bool? crashReportingEnabled,
      String? applicationName,
      bool? enableLoggingInVSCode}) {
    return AgentConfiguration(
        appKey: appKey ?? this.appKey,
        collectorURL: collectorURL ?? this.collectorURL,
        screenshotURL: screenshotURL ?? this.screenshotURL,
        screenshotsEnabled: screenshotsEnabled ?? this.screenshotsEnabled,
        loggingLevel: loggingLevel ?? this.loggingLevel,
        crashReportCallback: crashReportCallback ?? this.crashReportCallback,
        crashReportingEnabled:
            crashReportingEnabled ?? this.crashReportingEnabled,
        applicationName: applicationName ?? this.applicationName,
        enableLoggingInVSCode:
            enableLoggingInVSCode ?? this.enableLoggingInVSCode);
  }
}
