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

  testWidgets('Info points success method is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'beginCall':
        case 'endCallWithSuccess':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    await Instrumentation.trackCall(
        uniqueCallId: "1234",
        className: "foo",
        methodName: "bar",
        methodArgs: [1, 2],
        methodBody: () {
          return 1 + 2;
        });

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('beginCall', arguments: {
        "callId": "1234",
        "className": "foo",
        "methodName": "bar",
        "methodArgs": [1, 2]
      }),
      isMethodCall('endCallWithSuccess', arguments: {
        "callId": "1234",
        "result": 3,
      }),
    ]);
  });

  testWidgets('Info points exception method is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'beginCall':
        case 'endCallWithError':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    final exception = Exception("fail");
    await Instrumentation.trackCall(
        uniqueCallId: "1234",
        className: "foo",
        methodName: "bar",
        methodArgs: [1, 2],
        methodBody: () {
          throw exception;
        });

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('beginCall', arguments: {
        "callId": "1234",
        "className": "foo",
        "methodName": "bar",
        "methodArgs": [1, 2]
      }),
      isMethodCall('endCallWithError', arguments: {
        "callId": "1234",
        "error": {"message": exception.toString()},
      }),
    ]);
  });

  testWidgets('Info points async call method is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'beginCall':
        case 'endCallWithSuccess':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    await Instrumentation.trackCall(
        uniqueCallId: "1234",
        className: "foo",
        methodName: "bar",
        methodBody: () async {
          return tester.runAsync(() async {
            return 1 + 2;
          });
        });

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('beginCall', arguments: {
        "callId": "1234",
        "className": "foo",
        "methodName": "bar",
        "methodArgs": null,
      }),
      isMethodCall('endCallWithSuccess', arguments: {
        "callId": "1234",
        "result": 3,
      }),
    ]);
  });

  testWidgets('Info points error method is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'beginCall':
        case 'endCallWithError':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    final error = Error();
    await Instrumentation.trackCall(
        uniqueCallId: "1234",
        className: "foo",
        methodName: "bar",
        methodArgs: [1, 2],
        methodBody: () {
          throw error;
        });

    expect(log, hasLength(2));
    expect(log, <Matcher>[
      isMethodCall('beginCall', arguments: {
        "callId": "1234",
        "className": "foo",
        "methodName": "bar",
        "methodArgs": [1, 2]
      }),
      isMethodCall('endCallWithError', arguments: {
        "callId": "1234",
        "error": {
          "message": "Error",
          "stackTrace": error.stackTrace.toString()
        },
      }),
    ]);
  });

  testWidgets('Info points method with no preset uniqueCallId works',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'beginCall':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    await Instrumentation.trackCall(
        className: "foo",
        methodName: "bar",
        methodArgs: [1, 2],
        uniqueCallId: null,
        methodBody: () {});

    expect(log, hasLength(1));
  });

  testWidgets('info points native error is converted to exception',
      (WidgetTester tester) async {
    const exceptionMessage = "Invalid key";
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      throw PlatformException(
          code: '500', details: exceptionMessage, message: "Message");
    });

    expect(
        () => Instrumentation.trackCall(
            className: "foo",
            methodName: "bar",
            methodArgs: [1, 2],
            uniqueCallId: null,
            methodBody: () {}),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
