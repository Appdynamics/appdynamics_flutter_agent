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
    final requests = await findRequestsBy(type: "anr");
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

  testWidgets("Check ANR beacons are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("anrButton");
    await tester.tapAndSettle("triggerSleepButton");
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
