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

  testWidgets('Change app key after initialization is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'changeAppKey':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const newKey = "AA-BBB-CCC";
    await Instrumentation.changeAppKey(newKey);

    expect(log, hasLength(1));
    expect(log, <Matcher>[
      isMethodCall('changeAppKey', arguments: {"newKey": newKey}),
    ]);
  });

  testWidgets(
      'Changing app key with error propagates native exception message.',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'changeAppKey':
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
        default:
          return null;
      }
    });

    const newKey = "123456";
    expect(
        () => Instrumentation.changeAppKey(newKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
