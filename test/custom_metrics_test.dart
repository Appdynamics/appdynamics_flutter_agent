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

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Custom metrics method is called natively', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportMetric':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    final customMetricName = "myCustomMetric";
    final customMetricValue = 123;

    await Instrumentation.reportMetric(
        name: customMetricName, value: customMetricValue);

    expect(log, hasLength(1));
    expect(log, <Matcher>[
      isMethodCall('reportMetric',
          arguments: {"name": customMetricName, "value": customMetricValue}),
    ]);
  });
}
