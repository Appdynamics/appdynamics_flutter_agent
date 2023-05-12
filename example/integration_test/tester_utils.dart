/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/app_state/app_state.dart';
import 'package:appdynamics_agent_example/routing/on_generate_route.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// App without any custom features (e.g. navigation observers) used to speed up
// testing.
class BareApp extends StatelessWidget {
  const BareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RoutePaths.settings,
      onGenerateRoute: onGenerateRoute,
      home: Scaffold(
        body: SizedBox(
          width: 200, // random values to not generated rendering problems.
          height: 300,
        ),
      ),
    );
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
    // send-beacons.com instantly flushes the beacons on the Android agent.
    final tracker = await RequestTracker.create("http://send-beacons.com");
    tracker.setResponseStatusCode(200);
    tracker.reportDone();
    await pumpAndSettle(const Duration(seconds: 6));
  }

  Future<void> tapAndSettle(String key) async {
    final widget = find.byKey(Key(key));
    await ensureVisible(widget);
    await tap(widget);
    await pumpAndSettle();
  }

  Future<void> goBack() async {
    final backButton = find.byTooltip('Back');
    await tap(backButton);
    await pumpAndSettle();
  }
}
