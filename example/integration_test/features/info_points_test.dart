/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  assertManualSyncCallBeaconSent() async {
    final methodInfo = {
      "cls": "InfoPoints",
      "icm": false,
      "mth": "_trackManualSyncCall"
    };

    final requests = await findRequestsBy(
        type: "method-call",
        methodInfo: methodInfo,
        methodArgs: "[1, 2]",
        returnValue: "3");
    expect(requests.length, 1);
  }

  assertManualAsyncCallBeaconSent() async {
    final methodInfo = {
      "icm": false,
      "cls": "InfoPoints",
      "mth": "_trackManualAsyncCall"
    };

    final requests = await findRequestsBy(
        type: "method-call",
        methodInfo: methodInfo,
        methodArgs: "[1, 2]",
        returnValue: "3");
    expect(requests.length, 1);
  }

  assertManualAsyncExceptionBeaconSent() async {
    final methodInfo = {
      "icm": false,
      "cls": "InfoPoints",
      "mth": "_trackManualAsyncException"
    };
    final returnValue = {
      "is_error": true,
      "message": Exception("trackCall async exception").toString()
    };

    final requests = await findRequestsBy(
        type: "method-call", methodInfo: methodInfo, returnValue: returnValue);
    expect(requests.length, 1);
  }

  assertManualSyncErrorBeaconSent() async {
    final methodInfo = {
      "cls": "InfoPoints",
      "mth": "_trackManualSyncError",
      "icm": false
    };

    // Test would be unstable if we hardcoded the stacktrace in the return
    // value, so we let it as is and manually check if the stacktrace was sent.
    final requests =
        await findRequestsBy(type: "method-call", methodInfo: methodInfo);
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

  testWidgets("Check manual sync info points are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("infoPointsButton");
    await tester.tapAndSettle("manualSyncCallButton");
    await tester.flushBeacons();
    await tester.assertManualSyncCallBeaconSent();
  });

  testWidgets("Check manual async info points are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("infoPointsButton");
    await tester.tapAndSettle("manualAsyncCallButton");
    await tester.flushBeacons();
    await tester.assertManualAsyncCallBeaconSent();
  });

  testWidgets("Check manual async exception info points are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("infoPointsButton");
    await tester.tapAndSettle("manualAsyncExceptionButton");
    await tester.flushBeacons();
    await tester.assertManualAsyncExceptionBeaconSent();
  });

  testWidgets("Check manual sync error info points are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("infoPointsButton");
    await tester.tapAndSettle("manualSyncErrorButton");
    await tester.flushBeacons();
    await tester.assertManualSyncErrorBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
