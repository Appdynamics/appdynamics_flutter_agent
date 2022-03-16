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

  testWidgets('agent shutdown is called natively', (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'shutdownAgent':
        case 'restartAgent':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    await Instrumentation.shutdownAgent();
    await Instrumentation.restartAgent();

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('shutdownAgent', arguments: null),
      isMethodCall('restartAgent', arguments: null),
    ]);
  });

  testWidgets('agent shutdown/restart native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.shutdownAgent(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => Instrumentation.restartAgent(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
