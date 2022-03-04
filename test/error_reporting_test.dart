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

  testWidgets('report error is correctly called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'reportError':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const message = "test";
    var exception = Exception(message);
    var error = Error();
    StackTrace randomStackTrace = StackTrace.fromString("""
#0      State.context.<anonymous closure> (package:flutter/src/widgets/framework.dart:942:9)
#1      State.context (package:flutter/src/widgets/framework.dart:948:6)
    """);

    const infoLevel = ErrorSeverityLevel.info;
    const warningLevel = ErrorSeverityLevel.warning;
    const criticalLevel = ErrorSeverityLevel.critical;

    await Instrumentation.reportException(exception,
        severityLevel: infoLevel, stackTrace: randomStackTrace);
    await Instrumentation.reportError(error, severityLevel: warningLevel);
    await Instrumentation.reportMessage(message,
        severityLevel: criticalLevel, stackTrace: randomStackTrace);

    expect(log, hasLength(3));
    expect(log, <Matcher>[
      isMethodCall('reportError', arguments: {
        "message": exception.toString(),
        "severity": infoLevel.index,
        "stackTrace": randomStackTrace.toString()
      }),
      isMethodCall('reportError', arguments: {
        "message": error.toString(),
        "severity": warningLevel.index,
        "stackTrace": error.stackTrace?.toString()
      }),
      isMethodCall(
        'reportError',
        arguments: {
          "message": message,
          "severity": criticalLevel.index,
          "stackTrace": randomStackTrace.toString()
        },
      ),
    ]);
  });

  testWidgets('error reporting native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    const message = "test";
    var exception = Exception(message);
    var error = Error();

    const infoLevel = ErrorSeverityLevel.info;
    const warningLevel = ErrorSeverityLevel.warning;
    const criticalLevel = ErrorSeverityLevel.critical;

    expect(
        () => Instrumentation.reportException(exception,
            severityLevel: infoLevel),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => Instrumentation.reportError(error, severityLevel: warningLevel),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => Instrumentation.reportMessage(message,
            severityLevel: criticalLevel),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
