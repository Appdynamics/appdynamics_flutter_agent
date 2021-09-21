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

  testWidgets('Custom metrics method is called natively',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportMetric':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

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
}
