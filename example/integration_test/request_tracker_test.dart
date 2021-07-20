/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';
import 'wiremock_utils.dart';

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Manual request tracking sends beacons",
      (WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final manualNetworkRequestsButton =
        find.byKey(Key("manualNetworkRequestsButton"));
    expect(manualNetworkRequestsButton, findsOneWidget);

    await tester.tap(manualNetworkRequestsButton);
    await tester.pumpAndSettle();

    final manualPOSTRequestButton = find.byKey(Key("manualPOSTRequestButton"));
    expect(manualPOSTRequestButton, findsOneWidget);

    // TODO: Mock http request as to not have to wait for it anymore.
    await tester.tap(manualPOSTRequestButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    final requestSentLabel = find.text("Success with 200.");
    expect(requestSentLabel, findsOneWidget);

    await flushBeacons();

    final requests = await findRequestsBy(
        url: "www.appdynamics.com",
        type: "network-request",
        hrc: "200",
        $is: "Manual HttpTracker");
    expect(requests.length, 1);
  });

  tearDown(() async {
    await clearServer();
  });
}
