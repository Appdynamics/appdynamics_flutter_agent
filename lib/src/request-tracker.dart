/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/globals.dart';

/*
* If the SDK does not automatically report your HTTP requests, use this class to explicitly
* list them. Note that most users will not need to use this class; check the documentation
* for the list of HTTP APIs that are automatically reported.
*
* Usage:
*
* ```dart
* try {
*    final tracker = await RequestTracker.create(urlString);
*
*    // optional: add server correlation headers
*    final headers = await RequestTracker.getServerCorrelationHeaders();
*
*    // use your custom request() implementation
*    final response = await request(url, headers);
*
*    tracker.setRequestHeaders(response.request.headers);
*    tracker.setResponseHeaders(response.headers);
*    tracker.setResponseStatusCode(response.statusCode);
*  } catch (error) {
*    tracker.setError(error.toString());
*  } finally {
*    tracker.reportDone();
*  }
* ```
*/
class RequestTracker {
  RequestTracker._() {}

  /// Create and configure a RequestTracker object before sending an HTTP request to track it manually.
  ///
  /// @param url The URL being requested.
  ///
  /// @warning `url` must not be `null`.
  /// @warning You must have called Instrumentation.start() with a valid appKey.
  static Future<RequestTracker> create(String url) async {
    var tracker = RequestTracker._();
    await channel.invokeMethod<void>('getRequestTrackerWithUrl', url);
    return tracker;
  }

  /// An error describing the failure to receive a response, if one occurred.
  ///
  /// If the request was successful, this should be left `null`.
  setError(String message, [String? stackTrace]) async {
    var adError = {
      "message": message,
      "stack": stackTrace ?? 'N/A',
    };
    await channel.invokeMethod<void>('setRequestTrackerErrorInfo', adError);
  }

  /// The status code of response, if one was received.
  ///
  /// If a response was received, this should be an an integer. If an error occurred and a
  /// response was not received, this should remain `null`.
  setResponseStatusCode(int statusCode) async {
    await channel.invokeMethod<void>('setRequestTrackerStatusCode', statusCode);
  }

  /// A dictionary representing the keys and values from the client's request header.
  ///
  /// Currently used for propagating the request's `Content-Length` header.
  setRequestHeaders(Map<String, dynamic> requestHeaders) async {
    await channel.invokeMethod<void>(
        'setRequestTrackerRequestHeaders', requestHeaders);
  }

  /// A dictionary representing the keys and values from the server’s response header.
  ///
  /// If an error occurred and a response was not received, this should be `null`.
  setResponseHeaders(Map<String, String> responseHeaders) async {
    await channel.invokeMethod<void>(
        'setRequestTrackerResponseHeaders', responseHeaders);
  }

  /// Stops tracking an HTTP request.
  ///
  /// Immediately after receiving a response or an error, set the appropriate properties and call this method
  /// to report the outcome of the HTTP request. You should not continue to use this object after calling
  /// this method -- if you need to track another request, create another RequestTracker.
  reportDone() async {
    await channel.invokeMethod<void>('requestTrackerReport');
  }

  /// Generate headers and use them to correlate requests with business
  /// transactions.
  ///
  /// Usage:
  /// Retrieve the list of headers and set those header values on each outgoing
  /// HTTP request. Also, ensure that you are passing all response headers to
  /// `RequestTracker` object itself via the `setResponseHeaders()` method.
  static Future<Map<String, String>> getServerCorrelationHeaders() async {
    var response = await channel
        .invokeMethod<Map<dynamic, dynamic>>('getServerCorrelationHeaders');
    return new Map<String, String>.from(response!);
  }
}
