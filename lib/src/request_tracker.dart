/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/globals.dart';

/// If the SDK does not automatically report your HTTP requests, use this
/// class to explicitly list them.
///
/// ```dart
/// try {
///    final tracker = await RequestTracker.create(urlString);
///
///    // optional: add server correlation headers
///    final headers = await RequestTracker.getServerCorrelationHeaders();
///
///    // use your custom request() implementation
///    final response = await request(url, headers);
///
///    tracker.setRequestHeaders(response.request.headers);
///      ..setResponseHeaders(response.headers);
///      ..setResponseStatusCode(response.statusCode);
///  } catch (error) {
///    tracker.setError(error.toString());
///  } finally {
///    tracker.reportDone();
///  }
/// ```
///
class RequestTracker {
  RequestTracker._();

  /// Create a [RequestTracker] to be configured for manually tracking an HTTP
  /// request to track it manually, with a non-null [url] and after having
  /// called [Instrumentation.start()].
  static Future<RequestTracker> create(String url) async {
    var tracker = RequestTracker._();
    await channel.invokeMethod<void>('getRequestTrackerWithUrl', url);
    return tracker;
  }

  /// Sets an error [message] describing the failure to receive a response,
  /// if such a failure occurred.
  ///
  /// If the request was successful, this should be left `null`.
  /// Additional [stackTrace] can be added.
  setError(String message, [String? stackTrace]) async {
    var adError = {
      "message": message,
      "stack": stackTrace ?? 'N/A',
    };
    await channel.invokeMethod<void>('setRequestTrackerErrorInfo', adError);
    return this;
  }

  /// The [statusCode] of the response, if one was received.
  ///
  /// If a response was received, this should be an an integer. If an error
  /// occurred and a response was not received, this should not be called.
  Future<RequestTracker> setResponseStatusCode(int statusCode) async {
    await channel.invokeMethod<void>('setRequestTrackerStatusCode', statusCode);
    return this;
  }

  /// A dictionary representing the keys and values from the client request's
  /// headers.
  ///
  /// Currently used for propagating the request's `Content-Length` header.
  Future<RequestTracker> setRequestHeaders(
      Map<String, dynamic> requestHeaders) async {
    await channel.invokeMethod<void>(
        'setRequestTrackerRequestHeaders', requestHeaders);
    return this;
  }

  /// A dictionary representing the keys and values from the server response's
  /// headers.
  ///
  /// If an error occurred and a response was not received, this not be called.
  Future<RequestTracker> setResponseHeaders(
      Map<String, String> responseHeaders) async {
    await channel.invokeMethod<void>(
        'setRequestTrackerResponseHeaders', responseHeaders);
    return this;
  }

  /// Stops tracking an HTTP request.
  ///
  /// Immediately after receiving a response or an error, set the appropriate
  /// properties and call this method to report the outcome of the HTTP request.
  /// You should not continue to use this object after calling this method --
  /// if you need to track another request, create another [RequestTracker].
  Future<RequestTracker> reportDone() async {
    await channel.invokeMethod<void>('requestTrackerReport');
    return this;
  }

  /// Generate headers and use them to correlate requests with business
  /// transactions.
  ///
  /// Usage:
  /// Retrieve the list of headers and set those header values on each outgoing
  /// HTTP request. Also, ensure that you are passing all response headers to
  /// the [RequestTracker] object itself via [setRequestHeaders()].
  static Future<Map<String, String>> getServerCorrelationHeaders() async {
    var response = await channel
        .invokeMethod<Map<dynamic, dynamic>>('getServerCorrelationHeaders');
    return Map<String, String>.from(response!);
  }
}
