/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../tester_utils.dart';
import '../../wiremock_utils.dart';

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

  assertBeaconSent() async {
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

    final actualHeaders = actualRequests[0]["request"]["headers"];

    final btHeaders = await RequestTracker.getServerCorrelationHeaders();
    btHeaders.forEach((key, value) {
      expect(actualHeaders[key.toLowerCase()], value);
    });
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets("TrackedHttpClient beacon same as RequestTracker beacon",
      (WidgetTester tester) async {
    // Force using test keyboard and don't simulate typing.
    // Needed because `WidgetTester.enterText()` was lagging  and failing test
    // on smaller emulator screens.
    // https://github.com/flutter/flutter/issues/87990
    binding.testTextInput.register();

    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("manualNetworkRequestsButton");
    await tester.redirectToLocalhost();
    await tester.tapAndSettle("manualClientGetRequestButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
