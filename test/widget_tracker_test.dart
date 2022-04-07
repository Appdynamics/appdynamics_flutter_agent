/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/src/activity_tracking/widget_tracker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TrackedWidget converts from and out of JSON correctly',
      (WidgetTester tester) async {
    const widgetName = "foo";
    final startDate = DateTime.utc(2021).toIso8601String();
    final endDate = DateTime.utc(2022).toIso8601String();

    final trackedWidget = TrackedWidget(
        widgetName: widgetName, startDate: startDate, endDate: endDate);
    trackedWidget.uuidString = "random-uuid";

    final converted = TrackedWidget.fromJson(trackedWidget.toJson());

    expect(converted.widgetName, trackedWidget.widgetName);
    expect(converted.uuidString, trackedWidget.uuidString);
    expect(converted.startDate, trackedWidget.startDate);
    expect(converted.endDate, trackedWidget.endDate);
  });

  testWidgets('Widget tracker manages TrackedWidgets correctly.',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackPageStart':
          return "random-uuid";
        case 'trackPageEnd':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    const widgetName = "Login";
    const widgetName2 = "Main Menu";

    await WidgetTracker.instance.trackWidgetStart(widgetName);
    await WidgetTracker.instance.trackWidgetStart(widgetName2);

    expect(WidgetTracker.instance.trackedWidgets.length, 2);
    expect(WidgetTracker.instance.trackedWidgets[widgetName]!.widgetName,
        widgetName);
    expect(WidgetTracker.instance.trackedWidgets[widgetName2]!.widgetName,
        widgetName2);

    await WidgetTracker.instance.trackWidgetEnd(widgetName);
    expect(WidgetTracker.instance.trackedWidgets.length, 1);

    await WidgetTracker.instance.trackWidgetEnd(widgetName2);
    expect(WidgetTracker.instance.trackedWidgets.length, 0);
  });

  testWidgets('Failing trackPageStart propagates native exception message.',
      (WidgetTester tester) async {
    const exceptionMessage = "Native exception";

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackPageStart':
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
        default:
          return null;
      }
    });

    expect(
        () => WidgetTracker.instance.trackWidgetStart("foo"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });

  testWidgets('Failing trackPageEnd propagates native exception message.',
      (WidgetTester tester) async {
    const exceptionMessage = "Native exception";

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackPageStart':
          return "random-uuid";
        case 'trackPageEnd':
          throw PlatformException(
              code: '500', details: exceptionMessage, message: "Message");
        default:
          return null;
      }
    });

    await WidgetTracker.instance.trackWidgetStart("foo");
    expect(
        () => WidgetTracker.instance.trackWidgetEnd("foo"),
        throwsA(predicate((e) =>
            e is Exception && e.toString() == "Exception: $exceptionMessage")));
  });
}
