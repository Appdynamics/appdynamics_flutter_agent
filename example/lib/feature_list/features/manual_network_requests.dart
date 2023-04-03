/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManualNetworkRequests extends StatefulWidget {
  const ManualNetworkRequests({Key? key}) : super(key: key);

  @override
  _ManualNetworkRequestsState createState() => _ManualNetworkRequestsState();
}

class _ManualNetworkRequestsState extends State<ManualNetworkRequests> {
  final urlFieldController =
      TextEditingController(text: "https://www.appdynamics.com");
  var responseText = "";
  var addServerCorrelation = true;

  @override
  void dispose() {
    urlFieldController.dispose();
    super.dispose();
  }

  Future<void> _sendGetRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isNotEmpty) {
      final url = Uri.parse(urlString);

      Map<String, List<String>> listHeaders = {};
      if (addServerCorrelation) {
        listHeaders = await RequestTracker.getServerCorrelationHeaders();
      }
      final headers =
          listHeaders.map((key, value) => MapEntry(key, value.first));
      final request = http.get(url, headers: headers);
      _sendManualReportedRequest(request, urlString);
    }
  }

  Future<void> _sendPostRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isNotEmpty) {
      final url = Uri.parse(urlString);

      Map<String, List<String>> listHeaders = {};
      if (addServerCorrelation) {
        listHeaders = await RequestTracker.getServerCorrelationHeaders();
      }
      final headers =
          listHeaders.map((key, value) => MapEntry(key, value.first));

      final request = http.get(url, headers: headers);
      _sendManualReportedRequest(request, urlString);
    }
  }

  Future<void> _sendManualReportedRequest(
      Future<http.Response> request, String urlString) async {
    setState(() {
      responseText = "Loading...";
    });

    final tracker = await RequestTracker.create(urlString);
    const intValue = 1234;
    const doubleValue = 123.456;
    const boolValue = true;
    const stringValue = "test string";
    final dateTimeValue = DateTime.utc(2021).toLocal();
    try {
      final response = await request;
      final requestHeaders =
          response.request!.headers.map((k, v) => MapEntry(k, <String>[v]));
      final responseHeaders =
          response.headers.map((k, v) => MapEntry(k, <String>[v]));

      await tracker.setResponseStatusCode(response.statusCode)
        ..setRequestHeaders(requestHeaders)
        ..setResponseHeaders(responseHeaders)
        ..setUserData("stringKey", stringValue)
        ..setUserDataBool("boolKey", boolValue)
        ..setUserDataDateTime("dateTimeValue", dateTimeValue)
        ..setUserDataDouble("doubleValue", doubleValue)
        ..setUserDataInt("intValue", intValue);
      setState(() {
        responseText = "Success with ${response.statusCode}.";
      });
    } catch (e) {
      setState(() {
        responseText = "Failed with ${e.toString()}.";
      });
      await tracker.setError(e.toString());
    } finally {
      await tracker.reportDone();
    }
  }

  Future<void> _sendHttpClientRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        responseText = "Loading...";
      });

      final url = Uri.parse(urlString);
      final client = TrackedHttpClient(http.Client());

      final response =
          await client.post(url, body: "[{\"type\": \"trackedhttpclient\"}]");
      setState(() {
        responseText = "Success with ${response.statusCode}.";
      });
    } catch (e) {
      setState(() {
        responseText = "Failed with ${e.toString()}.";
      });
    }
  }

  Future<void> _sendDioClientRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        responseText = "Loading...";
      });

      final dioClient = TrackedDioClient(Dio());
      final response = await dioClient.post(urlString,
          data: "[{\"type\": \"trackeddioclient\"}]");
      setState(() {
        responseText = "Success with ${response.statusCode}.";
      });
    } catch (e) {
      setState(() {
        responseText = "Failed with ${e.toString()}.";
      });
    }
  }

  Future<void> _sendDioInterceptorRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isEmpty) {
      return;
    }

    try {
      setState(() {
        responseText = "Loading...";
      });

      final dioClient = Dio();
      dioClient.interceptors.add(TrackedDioInterceptor());

      final response = await dioClient.post(urlString,
          data: "[{\"type\": \"trackeddiointerceptor\"}]");
      setState(() {
        responseText = "Success with ${response.statusCode}.";
      });
    } catch (e) {
      setState(() {
        responseText = "Failed with ${e.toString()}.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'Manual network requests',
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Add server correlation headers: '),
                  Checkbox(
                    value: addServerCorrelation,
                    onChanged: (bool? value) {
                      setState(() {
                        addServerCorrelation = value!;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const Key("requestTextField"),
                      controller: urlFieldController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter URL to report',
                          hintText: 'https://www.appdynamics.com'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      child: Text(
                        responseText,
                        textAlign: TextAlign.center,
                      ),
                      visible: responseText.isNotEmpty,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        key: const Key("manualGETRequestButton"),
                        child: const Text(
                            'Manual track GET request\n(+ user data)',
                            textAlign: TextAlign.center),
                        onPressed: _sendGetRequestButtonPressed),
                    ElevatedButton(
                        key: const Key("manualPOSTRequestButton"),
                        child: const Text('Manual track POST request',
                            textAlign: TextAlign.center),
                        onPressed: _sendPostRequestButtonPressed),
                    ElevatedButton(
                        key: const Key("manualHttpClientGetRequestButton"),
                        child: const Text('TrackedHttpClient GET request',
                            textAlign: TextAlign.center),
                        onPressed: _sendHttpClientRequestButtonPressed),
                    ElevatedButton(
                        key: const Key("manualDioClientGetRequestButton"),
                        child: const Text('TrackedDioClient GET request',
                            textAlign: TextAlign.center),
                        onPressed: _sendDioClientRequestButtonPressed),
                    ElevatedButton(
                        key: const Key("manualDioInterceptorGetRequestButton"),
                        child: const Text('TrackedDioInterceptor GET request',
                            textAlign: TextAlign.center),
                        onPressed: _sendDioInterceptorRequestButtonPressed),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
