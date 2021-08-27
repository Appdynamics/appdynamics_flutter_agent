/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

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

  testWidgets("Manual screenshots are properly reported.",
      (WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final screenshotsButton = find.byKey(Key("screenshotsButton"));
    await tester.scrollUntilVisible(screenshotsButton, 10);
    expect(screenshotsButton, findsOneWidget);
    await tester.tap(screenshotsButton);
    await tester.pumpAndSettle();

    final takeScreenshotButton = find.byKey(Key("takeScreenshotButton"));
    expect(takeScreenshotButton, findsOneWidget);

    final blockScreenshotsButton = find.byKey(Key("blockScreenshotsButton"));
    expect(blockScreenshotsButton, findsOneWidget);
    await tester.tap(blockScreenshotsButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(takeScreenshotButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    await flushBeacons();
    await tester.pump(Duration(seconds: 2));

    final screenshotRequests =
        await findRequestsBy(type: "screenshot", tiles: "<any>");
    expect(screenshotRequests.length, 0);

    final unblockScreenshotsButton =
        find.byKey(Key("unblockScreenshotsButton"));
    expect(unblockScreenshotsButton, findsOneWidget);
    await tester.tap(unblockScreenshotsButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(takeScreenshotButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    await flushBeacons();
    await tester.pump(Duration(seconds: 2));

    final newScreenshotRequests =
        await findRequestsBy(type: "screenshot", tiles: "<any>");
    expect(newScreenshotRequests.length, 1);
  });

  tearDown(() async {
    await clearServer();
  });
}
