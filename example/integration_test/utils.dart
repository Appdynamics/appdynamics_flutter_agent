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

extension TestHelpers on WidgetTester {
  // Jumps over the main screen, starting instrumentation with default configs.
  Future<void> jumpStartInstrumentation() async {
    await pumpWidget(const MyApp());
    final startButtonFinder =
        find.byKey(const Key("startInstrumentationButton"));
    expect(startButtonFinder, findsOneWidget);

    final featureListBarFinder = find.byKey(const Key("featureListAppBar"));
    expect(featureListBarFinder, findsNothing);

    await tap(startButtonFinder);
    await pumpAndSettle();

    expect(featureListBarFinder, findsOneWidget);
  }
}

Future<void> stubServerResponses() async {
  await setServerMapping({
    "request": {
      "method": "POST",
      "url": "/eumcollector/mobileMetrics?version=2"
    },
    "response": {"status": 200, "body": jsonEncode(serverAgentConfigStub)}
  });
}

// Force beacons to be sent.
Future<void> flushBeacons() async {
  final tracker = await RequestTracker.create("http://flush-beacons.com");
  tracker.setResponseStatusCode(200);
  tracker.reportDone();
}

Map<String, dynamic>? getBeaconRequestBody(Map<String, dynamic> request) {
  try {
    final List<dynamic> bodyList = jsonDecode(request["request"]["body"]);
    return Map<String, dynamic>.from(bodyList[0]);
  } catch (e) {
    return null;
  }
}
