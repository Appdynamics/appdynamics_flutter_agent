/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */


import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension NetworkRequests on WidgetTester {
  sendNetworkRequest() async {
    final requestTextField = find.byKey(const Key("requestTextField"));
    expect(requestTextField, findsOneWidget);

    final randomSuccessURL = serverRequestsUrl;
    await enterText(requestTextField, randomSuccessURL);
    await tapAndSettle("manualPOSTRequestButton");
  }

  assertBeaconSent() async {
    final requestSentLabel = find.text("Success with 200.");
    expect(requestSentLabel, findsOneWidget);

    final requests = await findRequestsBy(
        url: serverRequestsUrl,
        type: "network-request",
        hrc: "200",
        $is: "Manual HttpTracker");
    expect(requests.length, 1);
  }

  assertBeaconNotSent() async {
    final requestSentLabel = find.text("Success with 200.");
    expect(requestSentLabel, findsOneWidget);

    final requests = await findRequestsBy(
        url: serverRequestsUrl,
        type: "network-request",
        hrc: "200",
        $is: "Manual HttpTracker"
    );
    expect(requests.length, 0);
  }
}

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Manual request tracking sends beacons",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("manualNetworkRequestsButton");
    await tester.sendNetworkRequest();
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
