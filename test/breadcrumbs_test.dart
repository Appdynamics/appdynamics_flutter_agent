/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    mockPackageInfo();
  });

  testWidgets('breadcrumbs are called natively', (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'leaveBreadcrumb':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    const breadcrumb = "My breadcrumb";
    const crashSeverityLevel = BreadcrumbVisibility.crashesOnly;
    const crashSessionSeverityLevel = BreadcrumbVisibility.crashesAndSessions;

    Instrumentation.leaveBreadcrumb(breadcrumb, crashSeverityLevel);
    Instrumentation.leaveBreadcrumb(breadcrumb, crashSessionSeverityLevel);

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('leaveBreadcrumb', arguments: {
        "breadcrumb": breadcrumb,
        "mode": crashSeverityLevel.index
      }),
      isMethodCall('leaveBreadcrumb', arguments: {
        "breadcrumb": breadcrumb,
        "mode": crashSessionSeverityLevel.index
      })
    ]);
  });
}
