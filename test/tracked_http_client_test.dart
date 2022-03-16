/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TrackedHttpClient happy path methods are correctly called',
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
        case "requestTrackerReport":
          log.add(methodCall);
          return null;
        case "getServerCorrelationHeaders":
          log.add(methodCall);
          return {"foo": "bar"};
        default:
          return null;
      }
    });

    const urlString = "https://www.foo.com";
    const customHeaders = {"Content-Type": "json"};
    final client = TrackedHttpClient(MockClient((request) async {
      request.headers.addAll(customHeaders);
      return Response("{}", 200, request: request);
    }));
    // Also grabbing the headers here just to have what to compare with below.
    final headers = await RequestTracker.getServerCorrelationHeaders();
    final response = await client.get(Uri.parse(urlString));

    expect(log, hasLength(7));
    expect(log, <Matcher>[
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": client.tracker!.id, "url": urlString}),
      // TODO: Check also for custom headers when approved and installed:
      // https://github.com/dart-lang/http/pull/657
      isMethodCall('setRequestTrackerRequestHeaders', arguments: {
        "id": client.tracker!.id,
        "headers": headers // -> headers.addAll(customHeaders)
      }),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: {
          "id": client.tracker!.id,
          "statusCode": response.statusCode
        },
      ),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: {"id": client.tracker!.id, "headers": {}},
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": client.tracker!.id},
      )
    ]);
  });

  testWidgets('TrackedHttpClient error-path methods are called correctly',
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
        case "requestTrackerReport":
          log.add(methodCall);
          return null;
        case "getServerCorrelationHeaders":
          log.add(methodCall);
          return {"foo": "bar"};
        default:
          return null;
      }
    });

    final error = Error();
    const urlString = "https://www.foo.com";
    final client = TrackedHttpClient(MockClient((request) => throw error));

    await expectLater(() async => await client.get(Uri.parse(urlString)),
        throwsA(predicate((e) => e is Error)));

    expect(log, hasLength(4));
    expect(log, <Matcher>[
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": client.tracker!.id, "url": urlString}),
      isMethodCall('setRequestTrackerErrorInfo', arguments: {
        "id": client.tracker!.id,
        "errorDict": {
          "message": error.toString(),
          "stack": error.stackTrace.toString()
        }
      }),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": client.tracker!.id},
      ),
    ]);
  });

  testWidgets("TrackedHttpClient doesn't append correlation headers",
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
        case "requestTrackerReport":
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const urlString = "https://www.foo.com";
    final mockClient = MockClient((request) async {
      return Response("{}", 200, request: request);
    });
    final client = TrackedHttpClient(mockClient, addCorrelationHeaders: false);
    final response = await client.get(Uri.parse(urlString));

    expect(log, hasLength(5));
    expect(log, <Matcher>[
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": client.tracker!.id, "url": urlString}),
      isMethodCall('setRequestTrackerRequestHeaders', arguments: {
        "id": client.tracker!.id,
        "headers": {},
      }),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: {
          "id": client.tracker!.id,
          "statusCode": response.statusCode
        },
      ),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: {"id": client.tracker!.id, "headers": {}},
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": client.tracker!.id},
      )
    ]);
  });
}
