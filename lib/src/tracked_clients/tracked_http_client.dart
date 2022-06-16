/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:async';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:http/http.dart';

/// Use this client to track requests made via the `http` package.
///
/// ```dart
/// import 'package:http/http.dart' as http;
///
/// try {
///   final client = TrackedHttpClient(http.Client());
///   final response = await client.get(Uri.parse("https://www.appdynamics.com"));
///   // handle response
/// } catch (e) {
///   // handle error
/// }
/// ```
class TrackedHttpClient extends BaseClient {
  final Client _httpClient;
  final bool addCorrelationHeaders;
  RequestTracker? tracker;

  TrackedHttpClient(this._httpClient, {this.addCorrelationHeaders = true});

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (addCorrelationHeaders) {
      final correlationHeaders =
          await RequestTracker.getServerCorrelationHeaders();
      final headers =
          correlationHeaders.map((key, value) => MapEntry(key, value.first));
      request.headers.addAll(headers);
    }

    final urlString = request.url.toString();
    tracker = await RequestTracker.create(urlString);

    return _httpClient.send(request).then((response) async {
      final headers = response.request?.headers ?? request.headers;
      final requestHeaders = headers.map((k, v) => MapEntry(k, <String>[v]));
      final responseHeaders =
          response.headers.map((k, v) => MapEntry(k, <String>[v]));

      await tracker!.setRequestHeaders(requestHeaders);
      await tracker!.setResponseStatusCode(response.statusCode);
      await tracker!.setResponseHeaders(responseHeaders);

      return response;
    }, onError: (e, StackTrace stacktrace) async {
      await tracker!.setError(e.toString(), stacktrace.toString());
      throw e;
    }).whenComplete(() async {
      await tracker!.reportDone();
    });
  }
}
