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

  testWidgets('Custom metrics method is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportMetric':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const customMetricName = "myCustomMetric";
    const customMetricValue = 123;

    await Instrumentation.reportMetric(
        name: customMetricName, value: customMetricValue);

    expect(log, hasLength(1));
    expect(log, <Matcher>[
      isMethodCall('reportMetric',
          arguments: {"name": customMetricName, "value": customMetricValue}),
    ]);
  });

  testWidgets('custom metrics native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });
    expect(
        () => Instrumentation.reportMetric(name: "foo", value: 30),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
