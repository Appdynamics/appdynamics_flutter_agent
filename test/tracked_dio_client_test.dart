/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<MethodCall> log = <MethodCall>[];

  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
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
        return {
          "foo": ["bar"]
        };
      default:
        return null;
    }
  });

  // Used to not duplicate logic that has same results but only one different
  // parameter (i.e. request options).
  void happyPathTestLogic(
      Options? options, Map<String, List<String>> expectedHeaders) async {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final response =
          Response(requestOptions: options, data: "{}", statusCode: 200);
      handler.resolve(response);
    }));

    final client = TrackedDioClient(dio);
    const urlString = "https://www.foo.com";
    final response = await client.get(urlString, options: options);

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
      isMethodCall('setRequestTrackerRequestHeaders',
          arguments: {"id": client.tracker!.id, "headers": expectedHeaders}),
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
  }

  test('TrackedDioClient happy path methods works with initial headers',
      () async {
    log = [];
    final customHeaders = {"custom": "header"};
    final headers = await RequestTracker.getServerCorrelationHeaders();
    headers.addAll(
        customHeaders.map((key, value) => MapEntry(key, <String>[value])));
    happyPathTestLogic(Options(headers: customHeaders), headers);
  });

  test('TrackedDioClient happy path works with `null` options', () async {
    log = [];
    final headers = await RequestTracker.getServerCorrelationHeaders();
    happyPathTestLogic(null, headers);
  });

  test('TrackedDioClient happy path works with `null` option headers',
      () async {
    log = [];
    final headers = await RequestTracker.getServerCorrelationHeaders();
    happyPathTestLogic(Options(headers: null), headers);
  });

  test('TrackedDioClient error-path methods are called correctly', () async {
    log = [];

    const urlString = "https://www.foo.com";
    final error = DioError(
        type: DioErrorType.other,
        error: Error(),
        requestOptions: RequestOptions(path: urlString));

    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      throw error;
    }));

    final client = TrackedDioClient(dio);

    await expectLater(() async => await client.request(urlString),
        throwsA(predicate((e) => e is DioError)));

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

  test("TrackedDioClient doesn't call correlation headers method", () async {
    log = [];

    const urlString = "https://www.foo.com";
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final response =
          Response(requestOptions: options, data: "{}", statusCode: 200);
      handler.resolve(response);
    }));

    final client = TrackedDioClient(dio, addCorrelationHeaders: false);
    final response = await client.request(urlString);

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
