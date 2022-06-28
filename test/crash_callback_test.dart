/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('crash callback works', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'start':
          return null;
        default:
          return null;
      }
    });

    const crashReport = {
      "crashId": "foo",
      "exceptionName": "bar",
      "exceptionReason": "baz"
    };

    // Test CrashReportSummary methods and callback at the same time.
    crashReportCallback(List<CrashReportSummary> summaries) async {
      final report = summaries.first;
      expect(report.toJson().toString(), crashReport.toString());

      final newCrashReport = CrashReportSummary(
          crashId: report.crashId,
          exceptionName: report.exceptionName,
          exceptionReason: report.exceptionReason);

      expect(newCrashReport.crashId, report.crashId);
      expect(newCrashReport.exceptionName, report.exceptionName);
      expect(newCrashReport.exceptionReason, report.exceptionReason);
    }

    AgentConfiguration config = AgentConfiguration(
        appKey: 'AA-BBB-CCC', crashReportCallback: crashReportCallback);
    await Instrumentation.start(config);

    // Simulate crash being reported from native
    final data = const StandardMethodCodec()
        .encodeMethodCall(const MethodCall("onCrashReported", [crashReport]));
    tester.binding.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, null);
  });
}
