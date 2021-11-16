/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'globals.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockPackageInfo();
  });

  testWidgets('Change app key after initialization is called natively',
      (WidgetTester tester) async {
    final List<MethodCall> log = <MethodCall>[];

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel,
        (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'changeAppKey':
          log.add(methodCall);
          return null;
      }
    });

    const newKey = "AA-BBB-CCC";
    await Instrumentation.changeAppKey(newKey);

    expect(log, hasLength(1));
    expect(log, <Matcher>[
      isMethodCall('changeAppKey', arguments: {"newKey": newKey}),
    ]);
  });
}
