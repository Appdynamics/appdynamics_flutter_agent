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
  static const updatedSessionFrameName = "updatedSessionFrame";

  assertSessionStartBeaconSent() async {
    final startRequests = await findRequestsBy(
        type: "ui",
        event: "Session Frame Start",
        sessionFrameUuid: "<any>",
        sessionFrameName: "newSessionFrame");
    expect(startRequests.length, 1);
  }

  assertSessionUpdateBeaconSent() async {
    final updateRequests = await findRequestsBy(
      type: "ui",
      event: "Session Frame Update",
      sessionFrameUuid: "<any>",
      sessionFrameName: updatedSessionFrameName,
    );
    expect(updateRequests.length, 1);
  }

  assertSessionEndBeaconSent() async {
    final endRequests = await findRequestsBy(
      type: "ui",
      event: "Session Frame End",
      sessionFrameUuid: "<any>",
      sessionFrameName: updatedSessionFrameName,
    );
    expect(endRequests.length, 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check session frames are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("sessionFramesButton");
    await tester.tapAndSettle("startSessionFrameButton");
    await tester.flushBeacons();
    await tester.assertSessionStartBeaconSent();
    await tester.tapAndSettle("updateSessionFrameButton");
    await tester.flushBeacons();
    await tester.assertSessionUpdateBeaconSent();
    await tester.tapAndSettle("endSessionFrameButton");
    await tester.flushBeacons();
    await tester.assertSessionEndBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
