/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';

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

  /// Sets the logging level of the agent. Default is {@link LoggingLevel.none}.
  ///
  /// **WARNING:** Not recommended for production use.
  final LoggingLevel loggingLevel;

  AgentConfiguration({
    @required this.appKey,
    this.loggingLevel,
  });

  AgentConfiguration copyWith({
    String appKey,
    LoggingLevel loggingLevel,
  }) {
    return AgentConfiguration(
        appKey: appKey ?? this.appKey,
        loggingLevel: loggingLevel ?? this.loggingLevel);
  }
}
