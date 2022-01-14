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
          return {'foo': 'bar'};
      }
    });

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
}
