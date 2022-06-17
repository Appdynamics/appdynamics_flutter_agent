import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// Use this class to create a custom Dio [Interceptor] that tracks requests
/// automatically. Alternative to [TrackedDioClient].
///
/// ```dart
/// import 'package:dio/dio.dart';
///
/// try {
///   final dio = Dio();
///   dio.interceptors.add(TrackedDioInterceptor());
///   final response = await dio.post(urlString, data: {"foo": "bar"});
///   // handle response
/// } catch (e) {
///   // handle error
/// }
/// ```
class TrackedDioInterceptor implements Interceptor {
  final bool addCorrelationHeaders;

  final Map<RequestOptions, RequestTracker> _activeTrackers = {};

  @visibleForTesting
  final List<String> trackedIds = [];

  TrackedDioInterceptor({this.addCorrelationHeaders = true});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (addCorrelationHeaders) {
        final correlationHeaders =
            await RequestTracker.getServerCorrelationHeaders();

        final headers = correlationHeaders.map(
          (key, value) => MapEntry(key, value.first),
        );

        options.headers.addAll(headers);
      }

      var url = options.uri.toString();
      final tracker = await RequestTracker.create(url);
      trackedIds.add(tracker.id);
      _activeTrackers[options] = tracker;
    } finally {
      handler.next(options);
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      final tracker = _activeTrackers.remove(response.requestOptions);
      if (tracker != null) {
        await tracker.setResponseStatusCode(response.statusCode!);
        await _logResponse(response, tracker);
        await tracker.reportDone();
      }
    } finally {
      handler.next(response);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      final tracker = _activeTrackers.remove(err.requestOptions);
      if (tracker != null) {
        final statusCode = err.response?.statusCode;

        if (statusCode != null) {
          // Errors for when status code is not in accepted range should be recorded as normal
          await tracker.setResponseStatusCode(statusCode);
          await _logResponse(err.response, tracker);
        } else {
          // If status code is null, it means that the error is not a response, but rather a network error
          await tracker.setError(err.toString(), err.stackTrace.toString());
        }
        await tracker.reportDone();
      }
    } finally {
      handler.next(err);
    }
  }

  Future _logResponse(Response? response, RequestTracker tracker) async {
    if (response != null) {
      await tracker.setRequestHeaders(
        response.requestOptions.headers.map((k, v) => MapEntry(k, <String>[v])),
      );
      await tracker.setResponseHeaders(response.headers.map);
    }
  }
}
