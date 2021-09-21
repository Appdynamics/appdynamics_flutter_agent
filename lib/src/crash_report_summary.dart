/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

/// Called when a crash report is about to be sent.
///
/// Typically the [summaries] will have a size of 1, but if the app is crashing
/// very early during start up, [summaries] could be larger.
///
/// This method will be scheduled on the *main thread*, so any long
/// operations should be performed asynchronously.
///
/// [AgentConfiguration.crashReportingEnabled] must be `true` (default).
typedef void CrashReportCallback(List<CrashReportSummary> summaries);

class CrashReportSummary {
  /// Uniquely defines the crash, can be used as key to find full crash report.
  late final String crashId;

  /// May be `null` if no exception occurred.
  late final String? exceptionName;

  /// May be `null` if no exception occurred.
  late final String? exceptionReason;

  CrashReportSummary({
    required this.crashId,
    this.exceptionName = null,
    this.exceptionReason = null,
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
