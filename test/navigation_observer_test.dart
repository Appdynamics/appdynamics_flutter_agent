/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigation observer works', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackPageStart':
        case 'trackPageEnd':
          return null;
        default:
          return null;
      }
    });

    final observer = NavigationObserver();

    const route1Name = "Route1";
    const route2Name = "Route2";
    final route1 = MaterialPageRoute(
        settings: const RouteSettings(name: route1Name),
        builder: (BuildContext context) => null as StatelessWidget);
    final route2 = MaterialPageRoute(
        settings: const RouteSettings(name: route2Name),
        builder: (BuildContext context) => null as StatelessWidget);

    await observer.didPush(route1, null);
    await observer.didPush(route2, null);

    expect(WidgetTracker.instance.trackedWidgets.length, 2);
    expect(WidgetTracker.instance.trackedWidgets[route1Name]!.widgetName,
        route1Name);
    expect(WidgetTracker.instance.trackedWidgets[route2Name]!.widgetName,
        route2Name);

    await observer.didReplace(newRoute: route2, oldRoute: route1);
    expect(WidgetTracker.instance.trackedWidgets.length, 1);

    await observer.didPop(route2, null);
    expect(WidgetTracker.instance.trackedWidgets.length, 0);
  });
}
