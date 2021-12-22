/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockPackageInfo();
  });

  testWidgets('crash callback works', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'start':
          return null;
      }
    });

    const crashReport = {
      "crashId": "foo",
      "exceptionName": "bar",
      "exceptionReason": "baz"
    };

    crashReportCallback(List<CrashReportSummary> summaries) async {
      // Ensure coverage for CrashSummary object.
      final testToJson = summaries.first.toJson();
      expect(testToJson, crashReport);

      const newCrashId = "new";
      final testConstructor = CrashReportSummary(crashId: newCrashId);
      expect(testConstructor.crashId, newCrashId);
    }

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(
        appKey: appKey, crashReportCallback: crashReportCallback);
    await Instrumentation.start(config);

    // Simulate crash being reported from native
    const codec = StandardMethodCodec();
    final data = codec
        .encodeMethodCall(const MethodCall("onCrashReported", [crashReport]));
    tester.binding.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, null);
  });
}
