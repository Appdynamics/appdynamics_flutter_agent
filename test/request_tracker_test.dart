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

  const url = "https://www.appdynamics.com";
  const statusCode = 123;
  const errorMessage = "foo";
  const stackTrace = "bar";

  const intValue = 1234;
  const doubleValue = 123.456;
  const boolValue = true;
  const stringValue = "test string";
  final dateTimeValue = DateTime.utc(2021).toLocal();
  const stringKey = "stringKey";
  const boolKey = "boolKey";
  const dateTimeKey = "dateKey";
  const doubleKey = "doubleKey";
  const intKey = "intKey";

  testWidgets('Manual HTTP tracker methods work natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getRequestTrackerWithUrl':
        case "setRequestTrackerErrorInfo":
        case "setRequestTrackerStatusCode":
        case "setRequestTrackerResponseHeaders":
        case "setRequestTrackerRequestHeaders":
        case "setRequestTrackerUserData":
        case "setRequestTrackerUserDataDouble":
        case "setRequestTrackerUserDataLong":
        case "setRequestTrackerUserDataBoolean":
        case "setRequestTrackerUserDataDate":
        case "requestTrackerReport":
          log.add(methodCall);
          return null;
        case "getServerCorrelationHeaders":
          log.add(methodCall);
          return {'foo': ['bar']};
        default:
          return null;
      }
    });

    final headers = await RequestTracker.getServerCorrelationHeaders();
    final tracker = await RequestTracker.create(url)
      ..setRequestHeaders(headers)
      ..setResponseStatusCode(statusCode)
      ..setResponseHeaders(headers)
      ..setUserData(stringKey, stringValue)
      ..setUserDataBool(boolKey, boolValue)
      ..setUserDataDateTime(dateTimeKey, dateTimeValue)
      ..setUserDataDouble(doubleKey, doubleValue)
      ..setUserDataInt(intKey, intValue)
      ..setError(errorMessage, stackTrace)
      ..reportDone();

    expect(log, hasLength(12));
    expect(log, <Matcher>[
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": tracker.id, "url": url}),
      isMethodCall(
        'setRequestTrackerRequestHeaders',
        arguments: {"id": tracker.id, "headers": headers},
      ),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: {"id": tracker.id, "statusCode": statusCode},
      ),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: {"id": tracker.id, "headers": headers},
      ),
      isMethodCall(
        'setRequestTrackerUserData',
        arguments: {"id": tracker.id, "key": stringKey, "value": stringValue},
      ),
      isMethodCall(
        'setRequestTrackerUserDataBoolean',
        arguments: {"id": tracker.id, "key": boolKey, "value": boolValue},
      ),
      isMethodCall(
        'setRequestTrackerUserDataDate',
        arguments: {
          "id": tracker.id,
          "key": dateTimeKey,
          "value": dateTimeValue.toIso8601String()
        },
      ),
      isMethodCall(
        'setRequestTrackerUserDataDouble',
        arguments: {"id": tracker.id, "key": doubleKey, "value": doubleValue},
      ),
      isMethodCall(
        'setRequestTrackerUserDataLong',
        arguments: {"id": tracker.id, "key": intKey, "value": intValue},
      ),
      isMethodCall(
        'setRequestTrackerErrorInfo',
        arguments: {
          "id": tracker.id,
          "errorDict": {"message": errorMessage, "stack": stackTrace}
        },
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": tracker.id},
      )
    ]);
  });

  testWidgets(
      'request tracker creation methods native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => RequestTracker.getServerCorrelationHeaders(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => RequestTracker.create(url),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });

  testWidgets('request tracker methods native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case "getServerCorrelationHeaders":
          return {'foo': ['bar']};
        case "setRequestTrackerErrorInfo":
        case "setRequestTrackerStatusCode":
        case "setRequestTrackerResponseHeaders":
        case "setRequestTrackerRequestHeaders":
        case "setRequestTrackerUserData":
        case "setRequestTrackerUserDataDouble":
        case "setRequestTrackerUserDataLong":
        case "setRequestTrackerUserDataBoolean":
        case "setRequestTrackerUserDataDate":
        case "requestTrackerReport":
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
        default:
          return null;
      }
    });

    final headers = await RequestTracker.getServerCorrelationHeaders();
    final tracker = await RequestTracker.create(url);

    expect(
        () => tracker.setRequestHeaders(headers),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setResponseStatusCode(statusCode),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setResponseHeaders(headers),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setUserData(stringKey, stringValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setUserDataBool(boolKey, boolValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setUserDataDateTime(dateTimeKey, dateTimeValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setUserDataDouble(doubleKey, doubleValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setUserDataInt(intKey, intValue),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.setError(errorMessage, stackTrace),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
    expect(
        () => tracker.reportDone(),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
