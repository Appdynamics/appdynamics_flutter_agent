/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent/src/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Class used to track network requests.
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
///    await tracker.setRequestHeaders(response.request.headers);
///    await tracker.setResponseHeaders(response.headers);
///    await tracker.setResponseStatusCode(response.statusCode);
///    await tracker.setUserDataBool("secureCheck", false);
///  } catch (error) {
///    await tracker.setError(error.toString());
///  } finally {
///    await tracker.reportDone();
///  }
/// ```
class RequestTracker {
  final String id = UniqueKey().toString();

  RequestTracker._();

  /// Creates a [RequestTracker] to be configured for manually tracking an HTTP
  /// request to track it manually, with a non-null [url] and after having
  /// called [Instrumentation.start].
  ///
  /// Method might throw [Exception].
  static Future<RequestTracker> create(String url) async {
    try {
      final tracker = RequestTracker._();
      final args = {"id": tracker.id, "url": url};
      await channel.invokeMethod<void>('getRequestTrackerWithUrl', args);
      return tracker;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets an error [message] describing the failure to receive a response,
  /// if such a failure occurred.
  ///
  /// If the request was successful, this should be left `null`.
  /// Additional [stackTrace] can be added.
  ///
  /// Method might throw [Exception].
  setError(String message, [String? stackTrace]) async {
    try {
      final errorDict = {
        "message": message,
        "stack": stackTrace ?? 'N/A',
      };
      final args = {"id": id, "errorDict": errorDict};
      await channel.invokeMethod<void>('setRequestTrackerErrorInfo', args);
      return this;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Returns the [statusCode] of the response, if one was received.
  ///
  /// If a response was received, this should be an integer. If an error
  /// occurred, and a response was not received, this should not be called.
  ///
  /// Method might throw [Exception].
  Future<RequestTracker> setResponseStatusCode(int statusCode) async {
    try {
      final args = {"id": id, "statusCode": statusCode};
      await channel.invokeMethod<void>('setRequestTrackerStatusCode', args);
      return this;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a dictionary representing the keys and values from the client
  /// request's headers.
  ///
  /// Currently used for propagating the request's `Content-Length` header.
  ///
  /// Method might throw [Exception].
  Future<RequestTracker> setRequestHeaders(
      Map<String, List<String>> requestHeaders) async {
    try {
      final args = {"id": id, "headers": requestHeaders};
      await channel.invokeMethod<void>('setRequestTrackerRequestHeaders', args);
      return this;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a dictionary representing the keys and values from the server
  /// response's headers.
  ///
  /// If an error occurred and a response was not received, this should not be
  /// called.
  ///
  /// Method might throw [Exception].
  Future<RequestTracker> setResponseHeaders(
      Map<String, List<String>> responseHeaders) async {
    try {
      final args = {"id": id, "headers": responseHeaders};
      await channel.invokeMethod<void>(
          'setRequestTrackerResponseHeaders', args);
      return this;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Stops tracking an HTTP request.
  ///
  /// Immediately after receiving a response or an error set the appropriate
  /// properties and call this method to report the outcome of the HTTP request.
  /// You should not continue to use this object after calling this method --
  /// if you need to track another request, create another [RequestTracker].
  ///
  /// Method might throw [Exception].
  Future<RequestTracker> reportDone() async {
    try {
      final args = {
        "id": id,
      };
      await channel.invokeMethod<void>('requestTrackerReport', args);
      return this;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Generates headers used to correlate requests with business transactions.
  ///
  /// Usage:
  /// Retrieve the list of headers and set those header values on each outgoing
  /// HTTP request. Also, ensure that you are passing all response headers to
  /// the [RequestTracker] object itself via [setRequestHeaders].
  ///
  /// Method might throw [Exception].
  static Future<Map<String, List<String>>> getServerCorrelationHeaders() async {
    try {
      var response = await channel
          .invokeMethod<Map<dynamic, dynamic>>('getServerCorrelationHeaders');
      return response!.map(
          (key, value) => MapEntry(key.toString(), List<String>.from(value)));
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add [String] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// The [value] is also limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// Method might throw [Exception].
  Future<void> setUserData(
    String key,
    String value,
  ) async {
    try {
      final args = {"id": id, "key": key, "value": value};
      await channel.invokeMethod<void>('setRequestTrackerUserData', args);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [double] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// The [value] is also limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// Method might throw [Exception].
  Future<void> setUserDataDouble(
    String key,
    double value,
  ) async {
    try {
      final args = {"id": id, "key": key, "value": value};
      await channel.invokeMethod<void>('setRequestTrackerUserDataDouble', args);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [int] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// The [value] is also limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// Method might throw [Exception].
  Future<void> setUserDataInt(
    String key,
    int value,
  ) async {
    try {
      final args = {"id": id, "key": key, "value": value};
      await channel.invokeMethod<void>('setRequestTrackerUserDataLong', args);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [bool] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// The [value] is also limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// Method might throw [Exception].
  Future<void> setUserDataBool(
    String key,
    bool value,
  ) async {
    try {
      final args = {"id": id, "key": key, "value": value};
      await channel.invokeMethod<void>(
          'setRequestTrackerUserDataBoolean', args);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Sets a key-value pair identifier that will be included with this tracker.
  /// This identifier can be used to add the [DateTime] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// The [value] is also limited to [Instrumentation.maxUserDataStringLength]
  /// characters.
  ///
  /// Method might throw [Exception].
  Future<void> setUserDataDateTime(
    String key,
    DateTime value,
  ) async {
    try {
      final args = {
        "id": id,
        "key": key,
        "value": value.millisecondsSinceEpoch
      };
      await channel.invokeMethod<void>('setRequestTrackerUserDataDate', args);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }
}
