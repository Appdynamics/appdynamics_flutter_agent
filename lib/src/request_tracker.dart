/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/globals.dart';
import 'package:flutter/cupertino.dart';

/// If the SDK does not automatically report your HTTP requests, use this
/// class to explicitly list them.
///
/// ```dart
/// try {
///    final tracker = await RequestTracker.create(url);
///
///    // optional: add server correlation headers
///    final headers = await RequestTracker.getServerCorrelationHeaders();
///
///    // use your custom request() implementation
///    final response = await request(url, headers);
///
///    await tracker.setRequestHeaders(response.request.headers)
///      ..setResponseHeaders(response.headers)
///      ..setResponseStatusCode(response.statusCode)
///      ..setUserDataBool("secureCheck": false);
///  } catch (error) {
///    await tracker.setError(error.toString());
///  } finally {
///    await tracker.reportDone();
///  }
/// ```
class RequestTracker {
  final String id = UniqueKey().toString();

  RequestTracker._();

  /// Create a [RequestTracker] to be configured for manually tracking an HTTP
  /// request to track it manually, with a non-null [url] and after having
  /// called [Instrumentation.start()].
  static Future<RequestTracker> create(String url) async {
    final tracker = RequestTracker._();
    final args = {"id": tracker.id, "url": url};
    await channel.invokeMethod<void>('getRequestTrackerWithUrl', args);
    return tracker;
  }

  /// Sets an error [message] describing the failure to receive a response,
  /// if such a failure occurred.
  ///
  /// If the request was successful, this should be left `null`.
  /// Additional [stackTrace] can be added.
  setError(String message, [String? stackTrace]) async {
    final errorDict = {
      "message": message,
      "stack": stackTrace ?? 'N/A',
    };
    final args = {"id": id, "errorDict": errorDict};
    await channel.invokeMethod<void>('setRequestTrackerErrorInfo', args);
    return this;
  }

  /// The [statusCode] of the response, if one was received.
  ///
  /// If a response was received, this should be an an integer. If an error
  /// occurred and a response was not received, this should not be called.
  Future<RequestTracker> setResponseStatusCode(int statusCode) async {
    final args = {"id": id, "statusCode": statusCode};
    await channel.invokeMethod<void>('setRequestTrackerStatusCode', args);
    return this;
  }

  /// A dictionary representing the keys and values from the client request's
  /// headers.
  ///
  /// Currently used for propagating the request's `Content-Length` header.
  Future<RequestTracker> setRequestHeaders(
      Map<String, dynamic> requestHeaders) async {
    final args = {"id": id, "headers": requestHeaders};
    await channel.invokeMethod<void>('setRequestTrackerRequestHeaders', args);
    return this;
  }

  /// A dictionary representing the keys and values from the server response's
  /// headers.
  ///
  /// If an error occurred and a response was not received, this not be called.
  Future<RequestTracker> setResponseHeaders(
      Map<String, String> responseHeaders) async {
    final args = {"id": id, "headers": responseHeaders};
    await channel.invokeMethod<void>('setRequestTrackerResponseHeaders', args);
    return this;
  }

  /// Stops tracking an HTTP request.
  ///
  /// Immediately after receiving a response or an error, set the appropriate
  /// properties and call this method to report the outcome of the HTTP request.
  /// You should not continue to use this object after calling this method --
  /// if you need to track another request, create another [RequestTracker].
  Future<RequestTracker> reportDone() async {
    final args = {
      "id": id,
    };
    await channel.invokeMethod<void>('requestTrackerReport', args);
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

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add [string] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  Future<void> setUserData(
    String key,
    String value,
  ) async {
    final args = {"id": id, "key": key, "value": value};
    await channel.invokeMethod<void>('setRequestTrackerUserData', args);
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [double] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  Future<void> setUserDataDouble(
    String key,
    double value,
  ) async {
    final args = {"id": id, "key": key, "value": value};
    await channel.invokeMethod<void>('setRequestTrackerUserDataDouble', args);
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [int] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  Future<void> setUserDataInt(
    String key,
    int value,
  ) async {
    final args = {"id": id, "key": key, "value": value};
    await channel.invokeMethod<void>('setRequestTrackerUserDataLong', args);
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [bool] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  Future<void> setUserDataBool(
    String key,
    bool value,
  ) async {
    final args = {"id": id, "key": key, "value": value};
    await channel.invokeMethod<void>('setRequestTrackerUserDataBoolean', args);
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [DateTime] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  Future<void> setUserDataDateTime(
    String key,
    DateTime value,
  ) async {
    final args = {"id": id, "key": key, "value": value.toIso8601String()};
    await channel.invokeMethod<void>('setRequestTrackerUserDataDate', args);
  }
}
