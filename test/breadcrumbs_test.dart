/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('breadcrumbs are called natively', (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'leaveBreadcrumb':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const breadcrumb = "My breadcrumb";
    const crashSeverityLevel = BreadcrumbVisibility.crashesOnly;
    const crashSessionSeverityLevel = BreadcrumbVisibility.crashesAndSessions;

    await Instrumentation.leaveBreadcrumb(breadcrumb, crashSeverityLevel);
    await Instrumentation.leaveBreadcrumb(
        breadcrumb, crashSessionSeverityLevel);

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

  testWidgets('breadcrumbs native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.leaveBreadcrumb(
            "My breacrumb", BreadcrumbVisibility.crashesOnly),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
