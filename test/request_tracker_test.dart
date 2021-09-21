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

  testWidgets('Manual HTTP tracker success methods are called natively',
      (WidgetTester tester) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getRequestTrackerWithUrl':
        case "setRequestTrackerErrorInfo":
        case "setRequestTrackerStatusCode":
        case "setRequestTrackerResponseHeaders":
        case "setRequestTrackerRequestHeaders":
        case "requestTrackerReport":
          log.add(methodCall);
          return null;
        case "getServerCorrelationHeaders":
          log.add(methodCall);
          return {"foo": "bar"};
      }
    });

    const url = "http://www.appdynamics.com";
    const headers = {'foo': 'bar'};
    const responseCode = 123;
    const errorMessage = "foo";
    const stackTrace = "bar";

    await RequestTracker.create("http://www.appdynamics.com")
      ..setRequestHeaders(headers)
      ..setResponseStatusCode(responseCode)
      ..setResponseHeaders(headers)
      ..setError(errorMessage, stackTrace)
      ..reportDone();

    RequestTracker.getServerCorrelationHeaders();

    expect(log, hasLength(7));
    expect(log, <Matcher>[
      isMethodCall('getRequestTrackerWithUrl', arguments: url),
      isMethodCall(
        'setRequestTrackerRequestHeaders',
        arguments: headers,
      ),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: responseCode,
      ),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: headers,
      ),
      isMethodCall(
        'setRequestTrackerErrorInfo',
        arguments: {"message": errorMessage, "stack": stackTrace},
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: null,
      ),
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
    ]);
  });
}
