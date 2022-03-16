/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/app_state/app_state.dart';
import 'package:appdynamics_agent_example/routing/on_generate_route.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

class NavigationObserverApp extends StatelessWidget {
  const NavigationObserverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: RoutePaths.settings,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [NavigationObserver()]);
  }
}

extension on WidgetTester {
  startInstrumentationWithObserver() async {
    await pumpWidget(ChangeNotifierProvider(
        create: (context) => AppState(), child: const NavigationObserverApp()));
    await tapAndSettle("startInstrumentationButton");
  }

  assertPushStartBeaconSent() async {
    List<Map<String, dynamic>> requests;
    if (Platform.isIOS) {
      requests = await findRequestsBy(
          event: "View Controller Start",
          viewControllerName: RoutePaths.activityTrackingPush,
          type: "ui");
    } else {
      requests = await findRequestsBy(
          event: "Fragment Start",
          fragmentName: RoutePaths.activityTrackingPush,
          type: "ui");
    }
    expect(requests.length, 1);
  }

  assertPushEndBeaconSent() async {
    List<Map<String, dynamic>> requests;
    if (Platform.isIOS) {
      requests = await findRequestsBy(
          event: "View Controller End",
          viewControllerName: RoutePaths.activityTrackingPush,
          type: "ui");
    } else {
      requests = await findRequestsBy(
          event: "Fragment End",
          fragmentName: RoutePaths.activityTrackingPush,
          type: "ui");
    }
    expect(requests.length, 1);
  }

  assertReplaceStartBeaconSent() async {
    List<Map<String, dynamic>> requests;
    if (Platform.isIOS) {
      requests = await findRequestsBy(
          event: "View Controller Start",
          viewControllerName: RoutePaths.activityTrackingReplace,
          type: "ui");
    } else {
      requests = await findRequestsBy(
          event: "Fragment Start",
          fragmentName: RoutePaths.activityTrackingReplace,
          type: "ui");
    }
    expect(requests.length, 1);
  }

  assertReplaceEndBeaconSent() async {
    List<Map<String, dynamic>> requests;
    if (Platform.isIOS) {
      requests = await findRequestsBy(
          event: "View Controller End",
          viewControllerName: RoutePaths.activityTrackingReplace,
          type: "ui");
    } else {
      requests = await findRequestsBy(
          event: "Fragment end",
          fragmentName: RoutePaths.activityTrackingReplace,
          type: "ui");
    }
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

  testWidgets("Activity tracking beacons are sent",
      (WidgetTester tester) async {
    await tester.startInstrumentationWithObserver();
    await tester.tapAndSettle("activityTrackingButton");
    await tester.flushBeacons();
    await tester.tapAndSettle("pushScreenButton");
    await tester.flushBeacons();
    await tester.assertPushStartBeaconSent();
    await tester.tapAndSettle("backButton");
    await tester.flushBeacons();
    await tester.assertPushEndBeaconSent();
    await tester.tapAndSettle("replaceScreenButton");
    await tester.flushBeacons();
    await tester.assertReplaceStartBeaconSent();
    await tester.tapAndSettle("backButton");
    await tester.flushBeacons();
    await tester.assertReplaceEndBeaconSent();
    await tester.flushBeacons();
  });

  tearDown(() async {
    await clearServer();
  });
}
