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

  testWidgets('report error is correctly called natively',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportError':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    const message = "test";
    var exception = Exception(message);
    var error = Error();

    const infoLevel = ErrorSeverityLevel.info;
    const warningLevel = ErrorSeverityLevel.warning;
    const criticalLevel = ErrorSeverityLevel.critical;

    Instrumentation.reportException(exception, severityLevel: infoLevel);
    Instrumentation.reportError(error, severityLevel: warningLevel);
    Instrumentation.reportMessage(message, severityLevel: criticalLevel);

    expect(log, hasLength(3));
    expect(log, <Matcher>[
      isMethodCall('reportError', arguments: {
        "message": exception.toString(),
        "severity": infoLevel.index
      }),
      isMethodCall('reportError', arguments: {
        "message": error.toString(),
        "stackTrace": null.toString(),
        "severity": warningLevel.index
      }),
      isMethodCall('reportError',
          arguments: {"message": message, "severity": criticalLevel.index}),
    ]);
  });
}
