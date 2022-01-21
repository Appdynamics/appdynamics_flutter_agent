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

  testWidgets('Session frames methods are called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'startSessionFrame':
        case "updateSessionFrameName":
        case "endSessionFrame":
          log.add(methodCall);
          return null;
      }
    });

    const newSessionFrameName = "newSessionFrame";
    const updatedSessionFrameName = "updatedSessionFrame";

    final sessionFrame =
        await Instrumentation.startSessionFrame(newSessionFrameName);
    await sessionFrame.updateName(updatedSessionFrameName);
    await sessionFrame.end();

    expect(log, hasLength(3));
    expect(log, <Matcher>[
      isMethodCall('startSessionFrame',
          arguments: {"name": newSessionFrameName, "id": sessionFrame.id}),
      isMethodCall('updateSessionFrameName', arguments: {
        "newName": updatedSessionFrameName,
        "id": sessionFrame.id
      }),
      isMethodCall('endSessionFrame', arguments: sessionFrame.id),
    ]);
  });

  testWidgets(
      'session frames startSessionFrame() native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.startSessionFrame("newSessionFrame"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });

  testWidgets(
      'session frames other methods native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case "updateSessionFrameName":
        case "endSessionFrame":
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
      }
    });

    final sessionFrame =
        await Instrumentation.startSessionFrame("sessionFrame");

    expect(
        () => sessionFrame.updateName("foo"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => sessionFrame.end(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
