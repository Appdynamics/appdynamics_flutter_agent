/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io' show Platform;

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/cupertino.dart';
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

      final throwable = getBeaconRequestBody(requests[0])!["javaThrowable"];
      final exceptionName = throwable["exceptionClassName"];
      final List stackTraceElements = throwable["stackTraceElements"];

      expect(exceptionName, "java.lang.Throwable");
      expect(stackTraceElements.isNotEmpty, true);
    } else if (Platform.isIOS) {
      final requests =
          await findRequestsBy(type: "error", sev: severity, nsError: "<any>");
      expect(requests.length, 1);

      final domain = getBeaconRequestBody(requests[0])!["nsError"]["domain"];
      expect(domain, "Manual error report");
    }
  }

  assertCrashReported() async {
    final requests =
        await findRequestsBy(type: "crash-report", clrCrashReport: "<any>");
    expect(requests.length, 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check native and hybrid errors are properly reported",
      (WidgetTester tester) async {
    // We need to tweak the default onError so that it will silently catch
    // and report our Flutter exception, instead of crashing the test.
    final defaultOnError = FlutterError.onError!;
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (details.exceptionAsString() == "Exception: My Flutter exception") {
        return await Instrumentation.errorHandler(details);
      }

      return defaultOnError(details);
    };

    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("errorReportingButton");
    await tester.tapAndSettle("reportErrorButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("critical");
    await tester.tapAndSettle("reportExceptionButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("warning");
    await tester.tapAndSettle("reportMessageButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent("info");
    await tester.tapAndSettle("throwFlutterExceptionButton");
    await tester.assertCrashReported();
  });

  tearDown(() async {
    await clearServer();
  });
}
