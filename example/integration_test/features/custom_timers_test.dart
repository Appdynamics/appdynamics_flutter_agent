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

  testWidgets("Check custom timers are properly reported",
      (WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final customTimersButton = find.byKey(Key("customTimersButton"));
    await tester.scrollUntilVisible(customTimersButton, 10);
    expect(customTimersButton, findsOneWidget);

    await tester.tap(customTimersButton);
    await tester.pumpAndSettle();

    final startTimerButton = find.byKey(Key("startTimerButton"));
    expect(startTimerButton, findsOneWidget);

    final stopTimerButton = find.byKey(Key("stopTimerButton"));
    expect(stopTimerButton, findsOneWidget);

    await tester.tap(startTimerButton);
    await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.tap(stopTimerButton);

    await flushBeacons();
    await tester.pumpAndSettle(Duration(seconds: 2));

    final requests =
        await findRequestsBy(timerName: "My timer", type: "timer-event");
    expect(requests.length, 1);

    final body = getBeaconRequestBody(requests[0]);
    final int timerStart = body["sut"];
    final int timerEnd = body["eut"];
    expect(timerEnd > timerStart, true);
  });

  tearDown(() async {
    await clearServer();
  });
}
