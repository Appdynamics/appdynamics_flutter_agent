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

  test('Session frames methods are called natively', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'startSessionFrame':
        case "updateSessionFrameName":
        case "endSessionFrame":
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    final newSessionFrameName = "newSessionFrame";
    final updatedSessionFrameName = "updatedSessionFrame";

    final sessionFrame =
        await Instrumentation.startSessionFrame(newSessionFrameName);
    sessionFrame.updateName(updatedSessionFrameName);
    sessionFrame.end();

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
}
