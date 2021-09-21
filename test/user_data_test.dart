/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk/src/agent_configuration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    mockPackageInfo();
  });

  testWidgets('user data methods are called natively',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'setUserData':
        case 'setUserDataBoolean':
        case 'setUserDataDouble':
        case 'setUserDataLong':
        case 'setUserDataDate':
        case 'removeUserData':
        case 'removeUserDataBoolean':
        case 'removeUserDataDouble':
        case 'removeUserDataLong':
        case 'removeUserDataDate':
          log.add(methodCall);
          return null;
      }
    });

    const appKey = "AA-BBB-CCC";
    AgentConfiguration config = AgentConfiguration(appKey: appKey);
    await Instrumentation.start(config);

    const intKey = "intKey";
    const intValue = 1234;

    const stringKey = "stringKey";
    const stringValue = "1234";

    const doubleKey = "doubleKey";
    const doubleValue = 1234.5678;

    const boolKey = "boolKey";
    const boolValue = true;

    const dateTimeKey = "DateTimeKey";
    final dateTimeValue = DateTime.utc(2021);

    await Instrumentation.setUserDataInt(intKey, intValue);
    await Instrumentation.setUserDataDouble(doubleKey, doubleValue);
    await Instrumentation.setUserDataBool(boolKey, boolValue);
    await Instrumentation.setUserData(stringKey, stringValue);
    await Instrumentation.setUserDataDateTime(dateTimeKey, dateTimeValue);

    await Instrumentation.setUserDataInt(intKey, null);
    await Instrumentation.setUserDataDouble(doubleKey, null);
    await Instrumentation.setUserDataBool(boolKey, null);
    await Instrumentation.setUserData(stringKey, null);
    await Instrumentation.setUserDataDateTime(dateTimeKey, null);

    await Instrumentation.removeUserDataInt(intKey);
    await Instrumentation.removeUserDataDouble(doubleKey);
    await Instrumentation.removeUserDataBool(boolKey);
    await Instrumentation.removeUserData(stringKey);
    await Instrumentation.removeUserDataDateTime(dateTimeKey);

    expect(log, hasLength(15));
    expect(log, <Matcher>[
      isMethodCall('setUserDataLong',
          arguments: <String, dynamic>{"key": intKey, "value": intValue}),
      isMethodCall('setUserDataDouble',
          arguments: <String, dynamic>{"key": doubleKey, "value": doubleValue}),
      isMethodCall('setUserDataBoolean',
          arguments: <String, dynamic>{"key": boolKey, "value": boolValue}),
      isMethodCall('setUserData',
          arguments: <String, dynamic>{"key": stringKey, "value": stringValue}),
      isMethodCall('setUserDataDate', arguments: <String, dynamic>{
        "key": dateTimeKey,
        "value": dateTimeValue.toIso8601String()
      }),
      isMethodCall('removeUserDataLong', arguments: intKey),
      isMethodCall('removeUserDataDouble', arguments: doubleKey),
      isMethodCall('removeUserDataBoolean', arguments: boolKey),
      isMethodCall('removeUserData', arguments: stringKey),
      isMethodCall('removeUserDataDate', arguments: dateTimeKey),
      isMethodCall('removeUserDataLong', arguments: intKey),
      isMethodCall('removeUserDataDouble', arguments: doubleKey),
      isMethodCall('removeUserDataBoolean', arguments: boolKey),
      isMethodCall('removeUserData', arguments: stringKey),
      isMethodCall('removeUserDataDate', arguments: dateTimeKey),
    ]);
  });
}
