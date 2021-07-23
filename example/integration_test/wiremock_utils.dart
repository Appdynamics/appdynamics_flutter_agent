/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'utils.dart';

final serverUrl = "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:9999";
final serverRequestsUrl = "$serverUrl/__admin/requests";
final serverMappingsUrl = "$serverUrl/__admin/mappings";

Future<List<Map<String, dynamic>>> findRequestsBy({
  String? url,
  String? type,
  String? hrc,
  String? event,
  String? timerName,
  String? $is, // "$" -> reserved keyword workaround
}) async {
  final response = await http.get(Uri.parse(serverRequestsUrl));
  final Map<String, dynamic> json = jsonDecode(response.body);
  final List<dynamic> list = json["requests"];
  final jsonRequests =
      list.map((dynamic e) => e as Map<String, dynamic>).toList();

  final requestParameterMapping = {
    url: "url",
    type: "type",
    event: "event",
    hrc: "hrc",
    $is: "is",
    timerName: "timerName"
  };

  final requests = jsonRequests.where((request) {
    final body = getBeaconRequestBody(request);

    // checks if non-null parameters match the ones from the request.
    final bool results = requestParameterMapping.entries
        .where((e) => e.key != null)
        .fold(true, (value, e) {
      final bodyUrl = body[e.value].toString().toLowerCase();
      final lower = e.key.toString().toLowerCase();
      return value && bodyUrl.contains(lower);
    });

    return results;
  });

  return requests.toList();
}

Future<void> clearServerRequests() async {
  await http.delete(Uri.parse(serverRequestsUrl));
}

Future<void> setServerMapping(Map<String, dynamic> mapping) async {
  await http.post(Uri.parse(serverMappingsUrl), body: json.encode(mapping));
}

Future<void> clearServerMappings() async {
  await http.delete(Uri.parse(serverMappingsUrl));
}

Future<void> clearServer() async {
  await clearServerRequests();
  await clearServerMappings();
}
