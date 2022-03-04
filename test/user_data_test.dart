/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('user data methods are called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

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
        default:
          return null;
      }
    });

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

  testWidgets('user data native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.setUserDataInt(intKey, intValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.setUserDataDouble(doubleKey, doubleValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.setUserDataBool(boolKey, boolValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.setUserData(stringKey, stringValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.setUserDataDateTime(dateTimeKey, dateTimeValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));

    expect(
        () => Instrumentation.removeUserDataInt(intKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.removeUserDataDouble(doubleKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.removeUserDataBool(boolKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.removeUserData(stringKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => Instrumentation.removeUserDataDateTime(dateTimeKey),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
