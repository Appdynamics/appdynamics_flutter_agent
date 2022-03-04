import 'dart:async';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:http/http.dart' as http;

/// To collect metrics on network requests, you can use the HTTP client wrapper:
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
class TrackedHttpClient extends http.BaseClient {
  final http.Client _httpClient;
  bool addCorrelationHeaders;
  RequestTracker? tracker;

  TrackedHttpClient(this._httpClient, {this.addCorrelationHeaders = true});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (addCorrelationHeaders) {
      final correlationHeaders =
          await RequestTracker.getServerCorrelationHeaders();
      request.headers.addAll(correlationHeaders);
    }

    final urlString = request.url.toString();
    tracker = await RequestTracker.create(urlString);

    return _httpClient.send(request).then((response) async {
      final headers = response.request?.headers ?? request.headers;

      await tracker!.setRequestHeaders(headers);
      await tracker!.setResponseStatusCode(response.statusCode);
      await tracker!.setResponseHeaders(response.headers);

      return response;
    }, onError: (e, StackTrace stacktrace) async {
      await tracker!.setError(e.toString(), stacktrace.toString());
      throw e;
    }).whenComplete(() async {
      await tracker!.reportDone();
    });
  }
}
