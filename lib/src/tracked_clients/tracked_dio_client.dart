/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../../appdynamics_agent.dart';

/// Use this client to track requests made via the `dio` package (version <5).
/// For Dio version 5 and above, see [TrackedDioInterceptor].
///
/// ```dart
/// import 'package:dio/dio.dart';
///
/// try {
///   final dio = Dio();
///   final client = TrackedDioClient(dio);
///   final response = await client.post(urlString, data: "{"foo": "bar"}");
///   // handle response
/// } catch (e) {
///   // handle error
/// }
/// ```
class TrackedDioClient extends DioForNative {
  final Dio _dioClient;
  final bool addCorrelationHeaders;
  RequestTracker? tracker;

  TrackedDioClient(this._dioClient, {this.addCorrelationHeaders = true});

  @override
  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (addCorrelationHeaders) {
      final correlationHeaders =
          await RequestTracker.getServerCorrelationHeaders();
      final headers =
          correlationHeaders.map((key, value) => MapEntry(key, value.first));

      options ??= Options(headers: headers);
      if (options.headers != null) {
        options.headers!.addAll(headers);
      } else {
        options.headers = headers;
      }
    }

    final requestTracker = await RequestTracker.create(path);
    tracker = requestTracker;

    return _dioClient
        .request<T>(path,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress)
        .then((response) async {
      await requestTracker.setRequestHeaders(response.requestOptions.headers
          .map((k, v) => MapEntry(k, <String>[v])));
      await requestTracker.setResponseStatusCode(response.statusCode ?? 404);
      await requestTracker.setResponseHeaders(response.headers.map);
      return response;
    }, onError: (e, StackTrace stacktrace) async {
      if (e is DioException) {
        await requestTracker.setError(e.toString(), e.stackTrace.toString());
      } else {
        // All errors seem to be wrapped inside DioException, so we can't force
        // coverage for another type of error, but this case will still be
        // handled, just in case.
        await requestTracker.setError(e.toString(), stacktrace.toString());
      }
      throw e;
    }).whenComplete(() async {
      await requestTracker.reportDone();
    });
  }
}
