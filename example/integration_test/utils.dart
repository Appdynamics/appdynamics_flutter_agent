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

// Jumps over the main screen, starting instrumentation with default configs.
Future<void> jumpStartInstrumentation(WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  final startButtonFinder = find.byKey(Key("startInstrumentationButton"));
  expect(startButtonFinder, findsOneWidget);

  final featureListBarFinder = find.byKey(Key("featureListAppBar"));
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
    "response": {"status": 200, "body": "{}"}
  });
}

// Force beacons to be send.
Future<void> flushBeacons() async {
  final tracker = await RequestTracker.create("http://flush-beacons.com");
  tracker.setResponseStatusCode(200);
  tracker.reportDone();
}

// Shortcut to get body of beacon requests.
Map<String, dynamic> getBeaconRequestBody(Map<String, dynamic> request) {
  final List<dynamic> bodyList = jsonDecode(request["request"]["body"]);
  return Map<String, dynamic>.from(bodyList[0]);
}
