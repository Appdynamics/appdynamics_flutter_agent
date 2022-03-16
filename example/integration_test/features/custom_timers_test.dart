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
  assertBeaconSent() async {
    final requests =
        await findRequestsBy(timerName: "My timer", type: "timer-event");
    expect(requests.length, 1);

    final body = getBeaconRequestBody(requests[0])!;
    final int timerStart = body["sut"];
    final int timerEnd = body["eut"];
    expect(timerEnd > timerStart, true);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check custom timers are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("customTimersButton");
    await tester.tapAndSettle("startTimerButton");
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tapAndSettle("stopTimerButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
