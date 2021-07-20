/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

enum LoggingLevel { none, info, verbose }

/// Configuration object for the AppDynamics SDK.
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
/// **NOTE:** Replace "ABC-DEF-GHI" with your actual application key.
///
/// For more specialized use cases, like using an on-premise collector, use the
/// other, more advanced options supported by this class.
class AgentConfiguration {
  /// Sets the application key used by the SDK. (required)
  final String appKey;

  /// The URL of the collector. It should be compliant with "1.4. Hierarchical URI and
  /// Relative Forms" of [RFC2396](https://www.ietf.org/rfc/rfc2396.txt).
  ///
  /// The SDK will send beacons to this collector.
  final String collectorURL;

  /// Sets the logging level of the agent. Default is {@link LoggingLevel.none}.
  ///
  /// **WARNING:** Not recommended for production use.
  final LoggingLevel loggingLevel;

  AgentConfiguration({
    required this.appKey,
    this.collectorURL = "https://mobile.eum-appdynamics.com",
    this.loggingLevel = LoggingLevel.none,
  });

  AgentConfiguration copyWith({
    String? appKey,
    String? collectorURL,
    LoggingLevel? loggingLevel,
  }) {
    return AgentConfiguration(
      appKey: appKey ?? this.appKey,
      collectorURL: collectorURL ?? this.collectorURL,
      loggingLevel: loggingLevel ?? this.loggingLevel,
    );
  }
}
