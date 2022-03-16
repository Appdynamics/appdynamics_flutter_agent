/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../wiremock_utils.dart';
import '../tester_utils.dart';

extension on WidgetTester {
  assertNoBeaconsSent() async {
    final screenshotRequests =
        await findRequestsBy(type: "screenshot", tiles: "<any>");
    expect(screenshotRequests.length, 0);
  }

  assertBeaconsSent() async {
    final newScreenshotRequests =
        await findRequestsBy(type: "screenshot", tiles: "<any>");
    expect(newScreenshotRequests.length, 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Manual screenshots are properly reported.",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("screenshotsButton");
    await tester.tapAndSettle("blockScreenshotsButton");
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tapAndSettle("takeScreenshotButton");
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.flushBeacons();
    await tester.assertNoBeaconsSent();
    await tester.tapAndSettle("unblockScreenshotsButton");
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tapAndSettle("takeScreenshotButton");
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.flushBeacons();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.assertBeaconsSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
