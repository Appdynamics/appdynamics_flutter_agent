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

  testWidgets("Check session frames are properly reported",
      (WidgetTester tester) async {
    final newSessionFrameName = "newSessionFrame";
    final updatedSessionFrameName = "updatedSessionFrame";

    await jumpStartInstrumentation(tester);

    final sessionFramesButton = find.byKey(Key("sessionFramesButton"));
    await tester.scrollUntilVisible(sessionFramesButton, 10);
    expect(sessionFramesButton, findsOneWidget);

    await tester.tap(sessionFramesButton);
    await tester.pumpAndSettle();

    final startSessionFrameButton = find.byKey(Key("startSessionFrameButton"));
    expect(startSessionFrameButton, findsOneWidget);
    await tester.tap(startSessionFrameButton);
    await flushBeacons();
    await tester.pump(Duration(seconds: 2));

    final startRequests = await findRequestsBy(
      type: "ui",
      event: "Session Frame Start",
      sessionFrameUuid: "<any>",
      sessionFrameName: newSessionFrameName,
    );
    expect(startRequests.length, 1);

    final updateSessionFrameButton =
        find.byKey(Key("updateSessionFrameButton"));
    expect(updateSessionFrameButton, findsOneWidget);
    await tester.tap(updateSessionFrameButton);
    await flushBeacons();
    await tester.pump(Duration(seconds: 2));

    final updateRequests = await findRequestsBy(
      type: "ui",
      event: "Session Frame Update",
      sessionFrameUuid: "<any>",
      sessionFrameName: updatedSessionFrameName,
    );
    expect(updateRequests.length, 1);

    final endSessionFrameButton = find.byKey(Key("endSessionFrameButton"));
    expect(endSessionFrameButton, findsOneWidget);
    await tester.tap(endSessionFrameButton);
    await flushBeacons();
    await tester.pump(Duration(seconds: 2));

    final endRequests = await findRequestsBy(
      type: "ui",
      event: "Session Frame End",
      sessionFrameUuid: "<any>",
      sessionFrameName: updatedSessionFrameName,
    );
    expect(endRequests.length, 1);
  });

  tearDown(() async {
    await clearServer();
  });
}
