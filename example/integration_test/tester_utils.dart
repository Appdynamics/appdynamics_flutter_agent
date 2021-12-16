/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/app_state/app_state.dart';
import 'package:appdynamics_mobilesdk_example/routing/on_generate_route.dart';
import 'package:appdynamics_mobilesdk_example/routing/route_paths.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// App without any custom features (e.g. navigation observers) used to speed up
// testing.
class BareApp extends StatelessWidget {
  const BareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        initialRoute: RoutePaths.settings, onGenerateRoute: onGenerateRoute);
  }
}

extension TestHelpers on WidgetTester {
  // Jumps over the main screen, starting instrumentation with default configs.
  Future<void> jumpstartInstrumentation() async {
    await pumpWidget(ChangeNotifierProvider(
        create: (context) => AppState(), child: const BareApp()));

    final featureListBarFinder = find.byKey(const Key("featureListAppBar"));
    expect(featureListBarFinder, findsNothing);

    await tapAndSettle("startInstrumentationButton");

    expect(featureListBarFinder, findsOneWidget);
  }

  // Force beacons to be sent.
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
