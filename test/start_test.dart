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

  setUp(() {
    mockPackageInfo();
  });

  testWidgets('start() is called natively', (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'start':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    String version = "22.3.0-beta.8";

    AgentConfiguration config = AgentConfiguration(appKey: appKey);

    await Instrumentation.start(config);

    expect(log, hasLength(1));
    expect(log, <Matcher>[
      isMethodCall(
        'start',
        arguments: <String, dynamic>{
          "type": "Flutter",
          "version": version,
          "appKey": appKey,
          "loggingLevel": 0,
          "collectorURL": "https://mobile.eum-appdynamics.com",
          "screenshotURL": "https://mobile.eum-appdynamics.com",
          "screenshotsEnabled": true,
          "anrDetectionEnabled": true,
          "anrStackTraceEnabled": true,
          "crashReportingEnabled": true,
        },
      ),
    ]);
  });

  test('start native error is intercepted', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      throw PlatformException(
          code: "500", message: "start() threw native error.");
    });

    AgentConfiguration config = AgentConfiguration(appKey: "foo");
    expect(Instrumentation.start(config), throwsException);
  });
}
