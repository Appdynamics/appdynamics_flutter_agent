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
  assertSessionIncrement() async {
    final preSessionIncrementRequests =
        await findRequestsBy(type: "system-event");
    final postSessionIncrementRequests =
        await findRequestsBy(type: "network-request");

    final preBody = getBeaconRequestBody(preSessionIncrementRequests.first)!;
    final postBody = getBeaconRequestBody(postSessionIncrementRequests.last)!;

    final oldSessionCounter = preBody["sessionCounter"] as int;
    final newSessionCounter = postBody["sessionCounter"] as int;

    expect(newSessionCounter, oldSessionCounter + 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check session change increments correctly",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("sessionControlButton");
    await tester.tapAndSettle("startNextSession");
    await tester.flushBeacons();
    await tester.assertSessionIncrement();
  });

  tearDown(() async {
    await clearServer();
  });
}
