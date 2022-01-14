/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

final serverUrl = "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:9999";
final serverRequestsUrl = "$serverUrl/__admin/requests";
final serverMappingsUrl = "$serverUrl/__admin/mappings";

var serverAgentConfigStub = {
  "agentConfig": {
    "enableScreenshot": true,
    "screenshotUseCellular": true,
    "enableAnrDetection": true,
    "enableAnrStackTrace": true,
    "autoScreenshot": false,
    "timestamp": 9999999999,
    "anrThreshold": 3000,
    "deviceMetricsConfigurations": {
      "enableMemory": false,
      "enableStorage": false,
      "enableBattery": false,
      "criticalMemoryThresholdPercentage": 90,
      "criticalBatteryThresholdPercentage": 90,
      "criticalStorageThresholdPercentage": 90,
      "collectionFrequencyMins": 2
    }
  }
};

// All `http` responses will be 400 if we don't disable this.
void disableHTTPClientOverriding() {
  HttpOverrides.global = null;
}

Future<void> mapAgentInitToReturnSuccess() async {
  await setServerMapping({
    "request": {
      "method": "POST",
      "url": "/eumcollector/mobileMetrics?version=2"
    },
    "response": {"status": 200, "body": jsonEncode(serverAgentConfigStub)}
  });
}

/// [jsonDecode]'s beacon's body and nested JSON values recursively.
Map<String, dynamic>? getBeaconRequestBody(Map<String, dynamic> request) {
  try {
    final List<dynamic> list = jsonDecode(request["request"]["body"]);
    final object = Map<String, dynamic>.from(list[0]);

    // Deserialize nested JSON's that bypassed `jsonDecode` above.
    MapEntry<String, dynamic> decode(MapEntry<String, dynamic> entry) {
      try {
        return decode(MapEntry(entry.key, jsonDecode(entry.value)));
      } catch (e) {
        return entry;
      }
    }

    final recursivelyDecoded = object.entries.map(decode);
    return Map<String, dynamic>.fromEntries(recursivelyDecoded);
  } catch (e) {
    return null;
  }
}

Map<String, dynamic> getBeaconRequestHeaders(Map<String, dynamic> request) {
  return Map<String, dynamic>.from(request["request"]["headers"]);
}

class AnyRequestValue {}

/// Checks request's bodies for specific parameters and values.
///
/// Can be used also to check the i.f key exists in body by specifying "<any>"
/// as parameter the value.
Future<List<Map<String, dynamic>>> findRequestsBy({
  dynamic url,
  dynamic type,
  dynamic hrc,
  dynamic userData,
  dynamic userDataDateTime,
  dynamic userDataBool,
  dynamic userDataDouble,
  dynamic userDataInt,
  dynamic event,
  dynamic timerName,
  dynamic text,
  dynamic sev,
  dynamic javaThrowable,
  dynamic nsError,
  dynamic userInfo,
  dynamic sessionFrameName,
  dynamic sessionFrameUuid,
  dynamic tiles,
  dynamic metricName,
  dynamic metricValue,
  dynamic methodArgs,
  dynamic methodInfo,
  dynamic returnValue,
  dynamic viewControllerName,
  dynamic fragmentName,
  dynamic $is, // "$" -> reserved keyword workaround
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
    text: "text",
    timerName: "timerName",
    sev: "sev",
    javaThrowable: "javaThrowable",
    nsError: "nsError",
    userInfo: "userInfo",
    sessionFrameName: "sessionFrameName",
    sessionFrameUuid: "sessionFrameUuid",
    tiles: "tiles",
    methodArgs: "args",
    methodInfo: "mid",
    returnValue: "ret",
    metricName: "metricName",
    metricValue: "val",
    viewControllerName: "viewControllerName",
    fragmentName: "fragmentName",
    userData: "userdata",
    userDataDateTime: "userdataDateTimestampMs",
    userDataBool: "userdataBoolean",
    userDataDouble: "userdataDouble",
    userDataInt: "userdataLong",
  };

  final requests = jsonRequests.where((request) {
    final body = getBeaconRequestBody(request);

    if (body == null) {
      return false;
    }

    // checks if non-null parameters match the ones from the request.
    final bool results = requestParameterMapping.entries
        .where((e) => e.key != null)
        .fold(true, (previous, e) {
      final bodyUrl = body[e.value].toString().toLowerCase();
      final lower = e.key.toString().toLowerCase();

      if (e.key == "<any>") {
        return previous && body.containsKey(e.value);
      }

      // Compare maps based on having the same letters.
      // Different ordered keys in maps are still a valid comparison.
      if (e.key is Map) {
        final sortedValue = bodyUrl.split("")..sort();
        final sortedMatch = lower.split("")..sort();
        final value = sortedValue.join().toString().trim();
        final match = sortedMatch.join().toString().trim();

        return previous && value.contains(match);
      }

      if (e.key is String) {
        return previous && bodyUrl.contains(lower);
      }

      return false;
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
