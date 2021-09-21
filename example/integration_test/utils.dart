/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'wiremock_utils.dart';

var serverAgentConfigStub = {
  "agentConfig": {
    "enableScreenshot": true,
    "screenshotUseCellular": true,
    "autoScreenshot": false,
    "timestamp": 1,
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

// Jumps over the main screen, starting instrumentation with default configs.
Future<void> jumpStartInstrumentation(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  final startButtonFinder = find.byKey(const Key("startInstrumentationButton"));
  expect(startButtonFinder, findsOneWidget);

  final featureListBarFinder = find.byKey(const Key("featureListAppBar"));
  expect(featureListBarFinder, findsNothing);

  await tester.tap(startButtonFinder);
  await tester.pumpAndSettle();

  expect(featureListBarFinder, findsOneWidget);
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

// Force beacons to be send.
Future<void> flushBeacons() async {
  final tracker = await RequestTracker.create("http://flush-beacons.com");
  tracker.setResponseStatusCode(200);
  tracker.reportDone();
}

// Shortcut to get body of beacon requests.
Map<String, dynamic>? getBeaconRequestBody(Map<String, dynamic> request) {
  try {
    final List<dynamic> bodyList = jsonDecode(request["request"]["body"]);
    return Map<String, dynamic>.from(bodyList[0]);
  } catch (e) {
    return null;
  }
}
