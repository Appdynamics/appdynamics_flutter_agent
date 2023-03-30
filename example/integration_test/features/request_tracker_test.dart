/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  // We need to send the request to a path that the wiremock local server will
  // register and that can be later queried. We can use the URL already stubbed
  // in setUp().
  static final successURL = "$serverUrl/eumcollector/mobileMetrics?version=2";

  redirectToLocalhost() async {
    final requestTextField = find.byKey(const Key("requestTextField"));
    await ensureVisible(requestTextField);
    expect(requestTextField, findsOneWidget);

    await enterText(requestTextField, successURL);
  }

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

  assertHttpTrackerBeaconSent() async {
    final requestSentLabel = find.text("Success with 200.");
    await ensureVisible(requestSentLabel);
    expect(requestSentLabel, findsOneWidget);

    final trackerRequests = await findRequestsBy(
      url: successURL,
      type: "network-request",
      hrc: "200",
      $is: "Manual HttpTracker",
    );
    expect(trackerRequests.length, 1);

    final actualRequests = await findRequestsBy(type: "trackedhttpclient");
    expect(actualRequests.length, 1);

    // Also assert correlation headers are added
    final actualHeaders = actualRequests[0]["request"]["headers"];
    final btHeaders = await RequestTracker.getServerCorrelationHeaders();
    btHeaders.forEach((key, value) {
      expect(actualHeaders[key.toLowerCase()], value.first);
    });
  }

  assertDioTrackerBeaconSent() async {
    final requestSentLabel = find.text("Success with 200.");
    await ensureVisible(requestSentLabel);
    expect(requestSentLabel, findsOneWidget);

    final trackerRequests = await findRequestsBy(
      url: successURL,
      type: "network-request",
      hrc: "200",
      $is: "Manual HttpTracker",
    );
    expect(trackerRequests.length, 2);

    final actualRequests = await findRequestsBy(type: "trackeddioclient");
    expect(actualRequests.length, 1);

    // Also assert correlation headers are added
    final Map<String, dynamic> actualHeaders =
        actualRequests[0]["request"]["headers"];
    final btHeaders = await RequestTracker.getServerCorrelationHeaders();
    btHeaders.forEach((key, value) {
      expect(actualHeaders[key.toLowerCase()], value.first);
    });
  }

  assertDioInterceptorBeaconSent() async {
    final requestSentLabel = find.text("Success with 200.");
    await ensureVisible(requestSentLabel);
    expect(requestSentLabel, findsOneWidget);

    final trackerRequests = await findRequestsBy(
      url: successURL,
      type: "network-request",
      hrc: "200",
      $is: "Manual HttpTracker",
    );
    expect(trackerRequests.length, 3);

    final actualRequests = await findRequestsBy(type: "trackeddiointerceptor");
    expect(actualRequests.length, 1);

    // Also assert correlation headers are added
    final Map<String, dynamic> actualHeaders =
        actualRequests[0]["request"]["headers"];
    final btHeaders = await RequestTracker.getServerCorrelationHeaders();
    btHeaders.forEach((key, value) {
      expect(actualHeaders[key.toLowerCase()], value.first);
    });
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Manual request tracking sends beacons",
      (WidgetTester tester) async {
    // Force using test keyboard and don't simulate typing.
    // Needed because `WidgetTester.enterText()` was lagging and failing test
    // on smaller emulator screens.
    // https://github.com/flutter/flutter/issues/87990
    binding.testTextInput.register();

    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("manualNetworkRequestsButton");
    await tester.sendNetworkRequest();
    await tester.flushBeacons();
    await tester.assertBeaconSent();
    await tester.redirectToLocalhost();
    await tester.tapAndSettle("manualHttpClientGetRequestButton");
    await tester.flushBeacons();
    await tester.assertHttpTrackerBeaconSent();
    await tester.tapAndSettle("manualDioClientGetRequestButton");
    await tester.flushBeacons();
    await tester.assertDioTrackerBeaconSent();
    await tester.tapAndSettle("manualDioInterceptorGetRequestButton");
    await tester.flushBeacons();
    await tester.assertDioInterceptorBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
