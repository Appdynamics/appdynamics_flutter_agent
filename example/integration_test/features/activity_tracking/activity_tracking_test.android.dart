/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/app_state/app_state.dart';
import 'package:appdynamics_mobilesdk_example/routing/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import '../../tester_utils.dart';
import '../../wiremock_utils.dart';
import 'navigation_app.dart';

extension on WidgetTester {
  startInstrumentationWithObserver() async {
    await pumpWidget(ChangeNotifierProvider(
        create: (context) => AppState(), child: const NavigationObserverApp()));
    await tapAndSettle("startInstrumentationButton");
  }

  assertPushStartBeaconSent() async {
    final requests = await findRequestsBy(
        event: "Fragment Start",
        fragmentName: RoutePaths.activityTrackingPush,
        type: "ui");

    expect(requests.length, 1);
  }

  assertPushEndBeaconSent() async {
    final requests = await findRequestsBy(
        event: "Fragment End",
        fragmentName: RoutePaths.activityTrackingPush,
        type: "ui");
    expect(requests.length, 1);
  }

  assertReplaceStartBeaconSent() async {
    final requests = await findRequestsBy(
        event: "Fragment Start",
        fragmentName: RoutePaths.activityTrackingReplace,
        type: "ui");
    expect(requests.length, 1);
  }

  assertReplaceEndBeaconSent() async {
    final requests = await findRequestsBy(
        event: "Fragment End",
        fragmentName: RoutePaths.activityTrackingReplace,
        type: "ui");
    expect(requests.length, 1);
  }
}

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Activity tracking beacons are sent",
      (WidgetTester tester) async {
    await tester.startInstrumentationWithObserver();
    await tester.tapAndSettle("activityTrackingButton", shouldScroll: true);
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
