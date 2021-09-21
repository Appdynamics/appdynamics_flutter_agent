/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'crash_report_summary.dart';

enum LoggingLevel { none, info, verbose }

/// Configuration object for the AppDynamics SDK.
///
/// ```dart
/// AgentConfiguration config = AgentConfiguration(
///     appKey: "ABC-DEF-GHI",
///     loggingLevel: LoggingLevel.verbose);
/// Instrumentation.start(config);
/// ```
/// **NOTE:** Replace "ABC-DEF-GHI" with your actual application key.
///
/// For more specialized use cases, like using an on-premise collector, use the
/// other, more advanced options supported by this class.
class AgentConfiguration {
  /// Sets the application key used by the SDK. (required)
  final String appKey;

  /// The URL of the collector. It should be compliant with "1.4. Hierarchical
  /// URI and Relative Forms" of
  /// [RFC2396](https://www.ietf.org/rfc/rfc2396.txt).
  ///
  /// The agent will send beacons to this collector.
  final String collectorURL;

  /// Sets the URL of the screenshot service to which the agent will upload
  /// screenshots.
  ///
  /// This is NOT your controller URL. You likely do not need to call this
  /// method unless you have an AppDynamics managed private cloud (very rare).
  ///
  /// **NOTE:** If you have an on-premise EUM Processor and set the collector
  /// URL in [collectorURL], then you do not need to call this method because
  /// the two URLs are the same, and the agent assumes that is the case.
  final String screenshotURL;

  /// Enables or disables screenshots (default = enabled).
  ///
  /// If enabled, the [Instrumentation.takeScreenshot] method will capture
  /// screenshots, and depending on the configuration in the controller,
  /// automatic screenshots can be taken. You can always disable screenshots
  /// entirely from your controller.
  ///
  /// If disabled, the [Instrumentation.takeScreenshot] method will NOT capture
  /// screenshots, and no automatic screenshots will be captured. You will NOT
  /// be able to enable screenshots from your controller.
  ///
  /// Most applications should leave this option enabled, and control the
  /// screenshots from the controller configuration page.
  final bool screenshotsEnabled;

  /// Sets the logging level of the agent. Default is [LoggingLevel.none].
  ///
  /// **WARNING:** Altering this value is not recommended for production use.
  final LoggingLevel loggingLevel;

  /// The agent supports usage of a callback function that receives an array of
  /// the native crashes that have been reported. You can use this callback to
  /// have access to crash reports.
  final CrashReportCallback? crashReportCallback;

  // TODO: Implement crash reporting
  final bool crashReportingEnabled;

  AgentConfiguration({
    required this.appKey,
    this.collectorURL = "https://mobile.eum-appdynamics.com",
    this.screenshotURL = "https://mobile.eum-appdynamics.com",
    this.loggingLevel = LoggingLevel.none,
    this.screenshotsEnabled = true,
    this.crashReportingEnabled = true,
    this.crashReportCallback,
  });

  /// Creates a new [AgentConfiguration] with possibility to overwrite
  /// existing properties.
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
  /// Instrumentation.start(config);
  /// ```
  AgentConfiguration copyWith(
      {String? appKey,
      String? collectorURL,
      String? screenshotURL,
      bool? screenshotsEnabled,
      LoggingLevel? loggingLevel,
      CrashReportCallback? crashReportCallback,
      bool? crashReportingEnabled}) {
    return AgentConfiguration(
        appKey: appKey ?? this.appKey,
        collectorURL: collectorURL ?? this.collectorURL,
        screenshotURL: screenshotURL ?? this.screenshotURL,
        screenshotsEnabled: screenshotsEnabled ?? this.screenshotsEnabled,
        loggingLevel: loggingLevel ?? this.loggingLevel,
        crashReportCallback: crashReportCallback ?? this.crashReportCallback,
        crashReportingEnabled:
            crashReportingEnabled ?? this.crashReportingEnabled);
  }
}
