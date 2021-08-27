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

  test('Screenshots methods are called natively', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'takeScreenshot':
        case "blockScreenshots":
        case "unblockScreenshots":
          log.add(methodCall);
          return null;
        case "screenshotsBlocked":
          log.add(methodCall);
          return true;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    Instrumentation.blockScreenshots();
    Instrumentation.unblockScreenshots();
    final areScreenshotsBlocked = await Instrumentation.screenshotsBlocked();
    expect(areScreenshotsBlocked, true);
    Instrumentation.takeScreenshot();

    expect(log, hasLength(4));
    expect(log, <Matcher>[
      isMethodCall('blockScreenshots', arguments: null),
      isMethodCall('unblockScreenshots', arguments: null),
      isMethodCall('screenshotsBlocked', arguments: null),
      isMethodCall('takeScreenshot', arguments: null),
    ]);
  });
}
