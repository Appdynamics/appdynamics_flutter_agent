/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

/// Used to receive reports on app crashing natively.
///
/// Typically, the [summaries] will have a size of 1, but if the app is crashing
/// very early during startup, [summaries] could be more extensive.
///
/// This method will be scheduled natively on the main thread, so any long
/// operations should be performed asynchronously.
///
/// [AgentConfiguration.crashReportingEnabled] must be `true` (default).
typedef CrashReportCallback = void Function(List<CrashReportSummary> summaries);

/// Object encompassing native crash report info.
class CrashReportSummary {
  /// Uniquely defines the crash and can be used as key to find the full crash
  /// report.
  late final String crashId;

  /// May be `null` if no exception occurred.
  late final String? exceptionName;

  /// May be `null` if no exception occurred.
  late final String? exceptionReason;

  CrashReportSummary({
    required this.crashId,
    this.exceptionName,
    this.exceptionReason,
  });

  CrashReportSummary.fromJson(Map<String, dynamic> json) {
    crashId = json["crashId"];
    exceptionName = json["exceptionName"];
    exceptionReason = json["exceptionReason"];
  }

  Map<String, dynamic> toJson() {
    return {
      'crashId': crashId,
      'exceptionName': exceptionName,
      'exceptionReason': exceptionReason,
    };
  }
}
