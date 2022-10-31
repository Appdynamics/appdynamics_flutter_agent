/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    File file = File("pubspec.yaml");
    String yamlString = file.readAsStringSync();
    Map yaml = loadYaml(yamlString);
    final version = yaml["version"];

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

  testWidgets('start native error is intercepted', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: "500", message: "start() threw native error.");
    });

    AgentConfiguration config = AgentConfiguration(appKey: "foo");
    expect(Instrumentation.start(config), throwsException);
  });
}
