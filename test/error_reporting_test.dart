/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk/src/agent_configuration.dart';
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

  test('report error is correctly called natively', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportError':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    final message = "test";
    final exception = Exception(message);
    final error = Error();

    final infoLevel = ErrorSeverityLevel.INFO;
    final warningLevel = ErrorSeverityLevel.WARNING;
    final criticalLevel = ErrorSeverityLevel.CRITICAL;

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
