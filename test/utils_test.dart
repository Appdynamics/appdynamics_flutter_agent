/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('utils methods are called natively correctly',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'crash':
        case 'sleep':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const duration = Duration(seconds: 5);
    await Instrumentation.crash();
    await Instrumentation.sleep(duration);

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('crash', arguments: null),
      isMethodCall('sleep', arguments: {"seconds": duration.inSeconds})
    ]);
  });

  testWidgets('utils methods return native error detail on PlatformException',
      (WidgetTester tester) async {
    const exceptionMessage = "foo";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'crash':
        case 'sleep':
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
        default:
          return null;
      }
    });

    expect(
        () => Instrumentation.crash(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.sleep(const Duration(seconds: 5)),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
