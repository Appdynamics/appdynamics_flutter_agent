/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('error handler called natively correctly',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'createCrashReport':
          log.add(methodCall);
          return null;
        default:
          return null;
      }
    });

    final error = Error();
    StackTrace randomStackTrace = StackTrace.fromString("""
#0      State.context.<anonymous closure> (package:flutter/src/widgets/framework.dart:942:9)
#1      State.context (package:flutter/src/widgets/framework.dart:948:6)
#2      _SettingsState._showCrashReportAlert (package:appdynamics_mobilesdk_example/settings/settings.dart82:18)
    """);
    final details =
        FlutterErrorDetails(exception: error, stack: randomStackTrace);
    await Instrumentation.errorHandler(details);

    expect(log, hasLength(1));
  });
}
