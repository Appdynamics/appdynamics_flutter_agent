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

  testWidgets('Screenshots methods are called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'takeScreenshot':
        case "blockScreenshots":
        case "unblockScreenshots":
          log.add(methodCall);
          return null;
        case "screenshotsBlocked":
          log.add(methodCall);
          return true;
        default:
          return null;
      }
    });

    await Instrumentation.blockScreenshots();
    await Instrumentation.unblockScreenshots();
    final areScreenshotsBlocked = await Instrumentation.screenshotsBlocked();
    expect(areScreenshotsBlocked, true);
    await Instrumentation.takeScreenshot();

    expect(log, hasLength(4));
    expect(log, <Matcher>[
      isMethodCall('blockScreenshots', arguments: null),
      isMethodCall('unblockScreenshots', arguments: null),
      isMethodCall('screenshotsBlocked', arguments: null),
      isMethodCall('takeScreenshot', arguments: null),
    ]);
  });

  testWidgets('screenshots native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.blockScreenshots(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.unblockScreenshots(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.screenshotsBlocked(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.takeScreenshot(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
