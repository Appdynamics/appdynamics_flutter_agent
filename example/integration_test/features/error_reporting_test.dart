/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  assertBeaconSent(String severity) async {
    if (Platform.isAndroid) {
      final requests = await findRequestsBy(
          type: "error", sev: severity, javaThrowable: "<any>");
      expect(requests.length, 1);

      final exceptionName = getBeaconRequestBody(requests[0])!["javaThrowable"]
          ["exceptionClassName"];
      expect(exceptionName, "java.lang.Throwable");
    } else if (Platform.isIOS) {
      final requests =
          await findRequestsBy(type: "error", sev: severity, nsError: "<any>");
      expect(requests.length, 1);

      final domain = getBeaconRequestBody(requests[0])!["nsError"]["domain"];
      expect(domain, "Manual error report");
    }
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check errors are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("errorReportingButton");
    await tester.tapAndSettle("reportErrorButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("critical");
  });

  testWidgets("Check exceptions are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("errorReportingButton");
    await tester.tapAndSettle("reportExceptionButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("warning");
  });

  testWidgets("Check messages are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("errorReportingButton");
    await tester.tapAndSettle("reportMessageButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("info");
  });

  tearDown(() async {
    await clearServer();
  });
}
