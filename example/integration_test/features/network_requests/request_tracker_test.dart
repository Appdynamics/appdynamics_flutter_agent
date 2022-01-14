/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../tester_utils.dart';
import '../../wiremock_utils.dart';

extension on WidgetTester {
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

    const intValue = 1234;
    const doubleValue = 123.456;
    const boolValue = true;
    const stringValue = "test string";

    final requests = await findRequestsBy(
      url: serverRequestsUrl,
      type: "network-request",
      hrc: "200",
      $is: "Manual HttpTracker",
      userData: {
        "stringKey": stringValue,
      },
      // we can't match date time exactly due to bridging lag
      userDataDateTime: "<any>",
      userDataInt: {
        "intValue": intValue,
      },
      userDataBool: {
        "boolKey": boolValue,
      },
      userDataDouble: {
        "doubleValue": doubleValue,
      },
    );

    expect(requests.length, 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
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
