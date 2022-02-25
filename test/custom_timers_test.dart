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

  testWidgets('custom timers are called natively', (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'startTimer':
        case 'stopTimer':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const timerName = "My timer";
    await Instrumentation.startTimer(timerName);
    await Instrumentation.stopTimer(timerName);

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('startTimer', arguments: timerName),
      isMethodCall('stopTimer', arguments: timerName),
    ]);
  });

  testWidgets('custom timers native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.startTimer("My timer"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => Instrumentation.stopTimer("My timer"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
