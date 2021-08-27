/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';
import '../wiremock_utils.dart';

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> runCommonConfiguration(WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final errorReportingButton = find.byKey(Key("errorReportingButton"));
    await tester.scrollUntilVisible(errorReportingButton, 10);
    expect(errorReportingButton, findsOneWidget);

    await tester.tap(errorReportingButton);
    await tester.pumpAndSettle();
  }

  testWidgets("Check errors are properly reported",
      (WidgetTester tester) async {
    await runCommonConfiguration(tester);

    final reportErrorButton = find.byKey(Key("reportErrorButton"));
    expect(reportErrorButton, findsOneWidget);
    await tester.tap(reportErrorButton);

    await flushBeacons();
    await tester.pumpAndSettle(Duration(seconds: 2));

    if (Platform.isAndroid) {
      final requests = await findRequestsBy(
          type: "error", sev: "critical", javaThrowable: "<any>");
      expect(requests.length, 1);

      final exceptionName = getBeaconRequestBody(requests[0])!["javaThrowable"]
          ["exceptionClassName"];
      expect(exceptionName, "java.lang.Throwable");
    } else if (Platform.isIOS) {
      final requests = await findRequestsBy(
          type: "error", sev: "critical", nsError: "<any>");
      expect(requests.length, 1);

      final domain = getBeaconRequestBody(requests[0])!["nsError"]["domain"];
      expect(domain, "Manual error report");
    }
  });

  testWidgets("Check exceptions are properly reported",
      (WidgetTester tester) async {
    await runCommonConfiguration(tester);

    final reportExceptionButton = find.byKey(Key("reportExceptionButton"));
    expect(reportExceptionButton, findsOneWidget);
    await tester.tap(reportExceptionButton);

    await flushBeacons();
    await tester.pumpAndSettle(Duration(seconds: 2));

    if (Platform.isAndroid) {
      final requests = await findRequestsBy(
          type: "error", sev: "warning", javaThrowable: "<any>");
      expect(requests.length, 1);

      final exceptionName = getBeaconRequestBody(requests[0])!["javaThrowable"]
          ["exceptionClassName"];
      expect(exceptionName, "java.lang.Throwable");
    } else if (Platform.isIOS) {
      final requests =
          await findRequestsBy(type: "error", sev: "warning", nsError: "<any>");
      expect(requests.length, 1);

      final domain = getBeaconRequestBody(requests[0])!["nsError"]["domain"];
      expect(domain, "Manual error report");
    }
  });

  testWidgets("Check messages are properly reported",
      (WidgetTester tester) async {
    await runCommonConfiguration(tester);

    final reportMessageButton = find.byKey(Key("reportMessageButton"));
    expect(reportMessageButton, findsOneWidget);
    await tester.tap(reportMessageButton);

    await flushBeacons();
    await tester.pumpAndSettle(Duration(seconds: 2));

    if (Platform.isAndroid) {
      final requests = await findRequestsBy(
          type: "error", sev: "info", javaThrowable: "<any>");
      expect(requests.length, 1);

      final exceptionName = getBeaconRequestBody(requests[0])!["javaThrowable"]
          ["exceptionClassName"];
      expect(exceptionName, "java.lang.Throwable");
    } else if (Platform.isIOS) {
      final requests =
          await findRequestsBy(type: "error", sev: "info", nsError: "<any>");
      expect(requests.length, 1);

      final domain = getBeaconRequestBody(requests[0])!["nsError"]["domain"];
      expect(domain, "Manual error report");
    }
  });

  tearDown(() async {
    await clearServer();
  });
}
