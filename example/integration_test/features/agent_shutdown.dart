/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';
import 'request_tracker_test.dart';

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      "Agent shutdown blocks sending requests and agent restart will reset it",
      (WidgetTester tester) async {
    // TODO: Switch to cascading `await`'s after proposals:
    // https://github.com/dart-lang/language/issues/25
    // https://github.com/dart-lang/sdk/issues/25986
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("agentShutdownButton");
    await tester.tapAndSettle("shutdownAgentButton");
    await tester.goBack();
    await tester.tapAndSettle("manualNetworkRequestsButton");
    await tester.sendNetworkRequest();
    await tester.flushBeacons();
    await tester.assertBeaconNotSent();
    await tester.goBack();
    await tester.tapAndSettle("agentShutdownButton");
    await tester.tapAndSettle("restartAgentButton");
    await tester.goBack();
    await tester.tapAndSettle("manualNetworkRequestsButton");
    await tester.sendNetworkRequest();
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
