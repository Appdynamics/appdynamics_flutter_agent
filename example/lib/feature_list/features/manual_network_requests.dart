/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/feature_list/utils/flush_beacons_app_bar.dart';

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

      Map<String, String> headers = <String, String>{};
      if (addServerCorrelation) {
        headers = await RequestTracker.getServerCorrelationHeaders();
      }
      final request = http.get(url, headers: headers);
      _sendManualReportedRequest(request, urlString);
    }
  }

  Future<void> _sendPostRequestButtonPressed() async {
    var urlString = urlFieldController.text;
    if (urlString.trim().isNotEmpty) {
      final url = Uri.parse(urlString);

      Map<String, String> headers = <String, String>{};
      if (addServerCorrelation) {
        headers = await RequestTracker.getServerCorrelationHeaders();
      }
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
    try {
      final response = await request;
      await tracker.setResponseStatusCode(response.statusCode)
        ..setRequestHeaders(response.request!.headers)
        ..setResponseHeaders(response.headers);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'Manual network requests',
      ),
      body: Center(
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                      child: const Text('Manual track GET request'),
                      onPressed: _sendGetRequestButtonPressed),
                  ElevatedButton(
                      key: const Key("manualPOSTRequestButton"),
                      child: const Text('Manual track POST request'),
                      onPressed: _sendPostRequestButtonPressed),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
