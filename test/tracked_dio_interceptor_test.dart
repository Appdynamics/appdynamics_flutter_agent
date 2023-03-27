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

  setUp(() {
    log = [];
  });

  // Used to not duplicate logic that has same results but only one different
  // parameter (i.e. request options).
  Future happyPathTestLogic(
    Options? options,
    Map<String, List<String>> expectedHeaders,
  ) async {
    final dio = Dio();

    final trackingInterceptor = TrackedDioInterceptor();
    dio.interceptors.add(trackingInterceptor);

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final response =
          Response(requestOptions: options, data: "{}", statusCode: 200);
      handler.resolve(response, true);
    }));

    const urlString = "https://www.foo.com";
    final response = await dio.get(urlString, options: options);
    final trackedId = trackingInterceptor.trackedIds.first;

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
          arguments: {"id": trackedId, "url": urlString}),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: {"id": trackedId, "statusCode": response.statusCode},
      ),
      isMethodCall('setRequestTrackerRequestHeaders',
          arguments: {"id": trackedId, "headers": expectedHeaders}),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: {"id": trackedId, "headers": {}},
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": trackedId},
      )
    ]);
  }

  test('TrackingInterceptor happy path methods works with initial headers',
      () async {
    final customHeaders = {"custom": "header"};
    final headers = await RequestTracker.getServerCorrelationHeaders();
    headers.addAll(
        customHeaders.map((key, value) => MapEntry(key, <String>[value])));
    await happyPathTestLogic(Options(headers: customHeaders), headers);
  });

  test('TrackingInterceptor happy path works with `null` options', () async {
    final headers = await RequestTracker.getServerCorrelationHeaders();
    await happyPathTestLogic(null, headers);
  });

  test('TrackingInterceptor happy path works with `null` option headers',
      () async {
    final headers = await RequestTracker.getServerCorrelationHeaders();
    await happyPathTestLogic(Options(headers: null), headers);
  });

  test('TrackingInterceptor error-path methods are called correctly', () async {
    const urlString = "https://www.foo.com";

    final dio = Dio();
    final trackingInterceptor = TrackedDioInterceptor();
    dio.interceptors.add(trackingInterceptor);

    final DioError error = DioError(
      type: DioErrorType.unknown,
      error: Error(),
      requestOptions: RequestOptions(path: urlString),
    );

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.reject(error, true);
    }));

    await expectLater(() async => await dio.request(urlString),
        throwsA(predicate((e) => e is DioError)));

    final trackedId = trackingInterceptor.trackedIds.first;

    expect(log, hasLength(4));
    expect(log, <Matcher>[
      isMethodCall(
        'getServerCorrelationHeaders',
        arguments: null,
      ),
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": trackedId, "url": urlString}),
      isMethodCall('setRequestTrackerErrorInfo', arguments: {
        "id": trackedId,
        "errorDict": {
          "message": error.toString(),
          "stack": error.stackTrace.toString()
        }
      }),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": trackedId},
      ),
    ]);
  }, skip: true);

  test("TrackingInterceptor doesn't call correlation headers method", () async {
    const urlString = "https://www.foo.com";
    final dio = Dio();

    final trackingInterceptor = TrackedDioInterceptor(
      addCorrelationHeaders: false,
    );
    dio.interceptors.add(trackingInterceptor);

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final response =
          Response(requestOptions: options, data: "{}", statusCode: 200);
      handler.resolve(response, true);
    }));

    final response = await dio.request(urlString);

    final trackedId = trackingInterceptor.trackedIds.first;

    expect(log, hasLength(5));
    expect(log, <Matcher>[
      isMethodCall('getRequestTrackerWithUrl',
          arguments: {"id": trackedId, "url": urlString}),
      isMethodCall(
        'setRequestTrackerStatusCode',
        arguments: {"id": trackedId, "statusCode": response.statusCode},
      ),
      isMethodCall('setRequestTrackerRequestHeaders', arguments: {
        "id": trackedId,
        "headers": {},
      }),
      isMethodCall(
        'setRequestTrackerResponseHeaders',
        arguments: {"id": trackedId, "headers": {}},
      ),
      isMethodCall(
        'requestTrackerReport',
        arguments: {"id": trackedId},
      )
    ]);
  });
}
