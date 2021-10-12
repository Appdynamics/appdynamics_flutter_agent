/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  openAgentShutdownScreen() async {
    final agentShutdownButton = find.byKey(const Key("agentShutdownButton"));
    await scrollUntilVisible(agentShutdownButton, 10);
    expect(agentShutdownButton, findsOneWidget);

    await tap(agentShutdownButton);
    await pumpAndSettle();
  }

  pressAgentShutdown() async {
    final shutdownAgentButton = find.byKey(const Key("shutdownAgentButton"));
    expect(shutdownAgentButton, findsOneWidget);

    await tap(shutdownAgentButton);
    await pumpAndSettle();
  }

  goBack() async {
    final backButton = find.byTooltip('Back');
    await tap(backButton);
    await pumpAndSettle();
  }

  openManualRequestScreen() async {
    final manualNetworkRequestsButton =
        find.byKey(const Key("manualNetworkRequestsButton"));
    await scrollUntilVisible(manualNetworkRequestsButton, 10);
    expect(manualNetworkRequestsButton, findsOneWidget);

    await tap(manualNetworkRequestsButton);
    await pumpAndSettle();
  }

  sendNetworkRequest() async {
    final manualPOSTRequestButton =
        find.byKey(const Key("manualPOSTRequestButton"));
    expect(manualPOSTRequestButton, findsOneWidget);

    final requestTextField = find.byKey(const Key("requestTextField"));
    expect(requestTextField, findsOneWidget);

    final randomSuccessURL = serverRequestsUrl;
    await enterText(requestTextField, randomSuccessURL);
    await tap(manualPOSTRequestButton);
    await pump(const Duration(seconds: 2));
  }

  assertBeaconSent() async {
    final requestSentLabel = find.text("Success with 200.");
    expect(requestSentLabel, findsOneWidget);

    await flushBeacons();
    await pump(const Duration(seconds: 2));

    final requests = await findRequestsBy(
        url: serverRequestsUrl,
        type: "network-request",
        hrc: "200",
        $is: "Manual HttpTracker");
    expect(requests.length, 1);
  }

  pressAgentRestart() async {
    final restartAgentButton = find.byKey(const Key("restartAgentButton"));
    expect(restartAgentButton, findsOneWidget);

    await tap(restartAgentButton);
    await pumpAndSettle();
  }

  assertBeaconNotSent() async {
    final requestSentLabel = find.text("Success with 200.");
    expect(requestSentLabel, findsOneWidget);

    await flushBeacons();
    await pump(const Duration(seconds: 2));

    final requests = await findRequestsBy(
        url: serverRequestsUrl,
        type: "network-request",
        hrc: "200",
        $is: "Manual HttpTracker");
    expect(requests.length, 0);
  }
}

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
    await tester.jumpStartInstrumentation();
    await tester.openAgentShutdownScreen();
    await tester.pressAgentShutdown();
    await tester.goBack();
    await tester.openManualRequestScreen();
    await tester.sendNetworkRequest();
    await tester.assertBeaconNotSent();
    await tester.goBack();
    await tester.openAgentShutdownScreen();
    await tester.pressAgentRestart();
    await tester.goBack();
    await tester.openManualRequestScreen();
    await tester.sendNetworkRequest();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
