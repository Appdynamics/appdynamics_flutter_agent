/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/app_state/app_state.dart';
import 'package:appdynamics_mobilesdk_example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

extension TestHelpers on WidgetTester {
  // Jumps over the main screen, starting instrumentation with default configs.
  Future<void> jumpstartInstrumentation() async {
    await pumpWidget(ChangeNotifierProvider(
        create: (context) => AppState(), child: const MyApp()));

    final featureListBarFinder = find.byKey(const Key("featureListAppBar"));
    expect(featureListBarFinder, findsNothing);

    await tapAndSettle("startInstrumentationButton");

    expect(featureListBarFinder, findsOneWidget);
  }

  // Force beacons to be send.
  Future<void> flushBeacons() async {
    final tracker = await RequestTracker.create("http://flush-beacons.com");
    tracker.setResponseStatusCode(200);
    tracker.reportDone();

    await pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> tapAndSettle(String key, {bool shouldScroll = false}) async {
    final widget = find.byKey(Key(key));

    if (shouldScroll) {
      await scrollUntilVisible(widget, 5);
    }

    expect(widget, findsOneWidget);

    await tap(widget);
    await pumpAndSettle();
  }

  Future<void> goBack() async {
    final backButton = find.byTooltip('Back');
    await tap(backButton);
    await pumpAndSettle();
  }
}
